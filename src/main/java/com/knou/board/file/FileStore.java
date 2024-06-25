package com.knou.board.file;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.server.ResponseStatusException;

import javax.imageio.ImageIO;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;

import static org.springframework.http.HttpStatus.BAD_REQUEST;

@Component
public class FileStore {

    @Value("${custom.path.upload-image}")
    private String imageDir;


    public String getFullPath(String fileName, String additionalPath) {
        return imageDir + additionalPath + fileName;
    }

    public UploadFile storeFile(MultipartFile file, String additionalPath) throws IOException {

        if (file.isEmpty()) {
            return null;
        }

        String originalFileName = file.getOriginalFilename();
        if (originalFileName.length() > 255) {
            throw new ResponseStatusException(BAD_REQUEST, "파일 이름이 너무 깁니다.");
        }

        String storeFileName = createStoreFileName(originalFileName);
        String fullPath = getFullPath(storeFileName, additionalPath);
        file.transferTo(new File(fullPath));

        return new UploadFile(originalFileName, storeFileName);
    }

    public boolean deleteFile(String storeFileName, String additionalPath) throws IOException {
        File file = new File(getFullPath(storeFileName, additionalPath));
        return Files.deleteIfExists(file.toPath());
    }

    public Boolean isSupportedImageType(MultipartFile file) {
        // 요청 헤더가 아닌 실제 파일 체크 (허용 포맷 : BMP, GIF, JPEG, PNG, TIFF, WBMP)
        try (InputStream input = file.getInputStream()) {
            try {
                ImageIO.read(input).toString();
            } catch (IOException e) {
                return false;
            }
        } catch (IOException e) {
            return false;
        }

        return true;
    }

    private String createStoreFileName(String originalFileName) {
        String ext = extractExtension(originalFileName);
        String uuid = java.util.UUID.randomUUID().toString();
        return uuid + "." + ext;
    }

    public String extractExtension(String originalFileName) {
        int index = originalFileName.lastIndexOf(".");
        return originalFileName.substring(index + 1);
    }
}
