package fun_.zhcode.ithome_lite

import android.annotation.SuppressLint
import javax.crypto.Cipher
import javax.crypto.spec.SecretKeySpec

object FlutterMethod {
    @ExperimentalUnsignedTypes
    @SuppressLint("GetInstance")
    fun encryDES(data: String): String {
        val password = "w^s(1#a@"
        val cipher = Cipher.getInstance("DES/ECB/NoPadding")
        val key = SecretKeySpec(password.toByteArray(), "DES")
        cipher.init(Cipher.ENCRYPT_MODE, key)
        val dataBytes = data.toByteArray()
        var dataSize = dataBytes.size
        val blockSize = cipher.blockSize
        if (dataSize % blockSize != 0) {
            dataSize += blockSize - (dataSize % blockSize)
        }
        val plainText = ByteArray(dataSize)
        System.arraycopy(dataBytes, 0, plainText, 0, dataBytes.size)
        return cipher.doFinal(plainText).toHexString()
    }

    @ExperimentalUnsignedTypes
    private fun ByteArray.toHexString() = asUByteArray().joinToString("") { it.toString(16).padStart(2, '0') }
}