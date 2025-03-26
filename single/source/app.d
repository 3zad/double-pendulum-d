import raylib;

import std.math.trigonometry;
import std.conv;
import std.stdio;

void main() {
    auto d = new DoublePendulum(200, 10, 3.141592/2, 9.81);
    d.run();
}

class DoublePendulum {
    private:
    double omega = 0;

    double l;
    double m;
    double t;
    double g;

    int originX = 256, originY = 256;

    public:
    this(double length, double mass, double theta, double gravity) {
        this.l = length;
        this.m = mass;
        this.t = theta;
        this.g = gravity;
    }

    void run() {
        SetConfigFlags(ConfigFlags.FLAG_WINDOW_RESIZABLE);
        SetConfigFlags(ConfigFlags.FLAG_WINDOW_ALWAYS_RUN);
        InitWindow(512, 512, "Single pendulum simulation");
        // High FPS to allow smooth and accurate simulations (possible to set dt smaller)
        SetTargetFPS(1000);

        scope (exit) CloseWindow();

        double dt = 0.01;
        while (!WindowShouldClose) {
            
            BeginDrawing();

            // RK4 formula for a single pendulum is overkill, but whatever.
            double k1_omega = dt * f1(t);

            double k2_omega = dt * f1(t + k1_omega / 2);

            double k3_omega = dt * f1(t + k2_omega / 2);

            double k4_omega = dt * f1(t + k3_omega);

            omega += (k1_omega + 2 * k2_omega + 2 * k3_omega + k4_omega) / 6;

            t += omega * dt;

            draw();
            EndDrawing();
        }
    }

    // Helper function for RK4
    double f1(double t1) {
        double num1 = -g * (2 * m) * sin(t1);
        double den = l * (2 * m);
        return (num1) / den;
    }

    void draw() {
        int x1 = originX + to!(int)(l * sin(t));
        int y1 = originY + to!(int)(l * cos(t));

        ClearBackground(Colors.BLACK);
        DrawLineV(Vector2(originX, originY), Vector2(x1, y1), Colors.WHITE);
        DrawCircle(x1, y1, m, Colors.RED);
    }
}
