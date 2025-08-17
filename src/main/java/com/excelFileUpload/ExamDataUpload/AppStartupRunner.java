package com.excelFileUpload.ExamDataUpload;

import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

import java.awt.Desktop;
import java.awt.GraphicsEnvironment;
import java.net.URI;

@Component
public class AppStartupRunner implements CommandLineRunner {

    @Override
    public void run(String... args) {
        try {
            Thread.sleep(4000);

            String url = "http://localhost:8080/loginPage";

            if (!GraphicsEnvironment.isHeadless() && Desktop.isDesktopSupported()) {
                Desktop.getDesktop().browse(new URI(url));
                System.out.println("Browser opened successfully.");
            } else {
                String os = System.getProperty("os.name").toLowerCase();

                if (os.contains("win")) {
                    Runtime.getRuntime().exec("rundll32 url.dll,FileProtocolHandler " + url);
                } else if (os.contains("mac")) {
                    Runtime.getRuntime().exec("open " + url);
                } else if (os.contains("nix") || os.contains("nux")) {
                    Runtime.getRuntime().exec("xdg-open " + url);
                } else {
                    System.out.println("Unsupported OS. Please open manually: " + url);
                }
            }

        } catch (Exception e) {
            System.err.println("⚠️ Failed to open browser automatically. Please open manually: http://localhost:8080/loginPage");
            System.err.println("Reason: " + e.getMessage());
        }
    }
}
