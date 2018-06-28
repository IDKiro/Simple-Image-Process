#include "pixtrans.h"

namespace qtcv
{
	// 将Mat转化为QImage
	QImage  cvMatToQImage(const cv::Mat &inMat)
	{
		switch (inMat.type())
		{
			// 8-bit, 4 channel
		case CV_8UC4:
		{
			QImage image(inMat.data,
				inMat.cols, inMat.rows,
				static_cast<int>(inMat.step),
				QImage::Format_ARGB32);

			return image;
		}

		// 8-bit, 3 channel
		case CV_8UC3:
		{
			QImage image(inMat.data,
				inMat.cols, inMat.rows,
				static_cast<int>(inMat.step),
				QImage::Format_RGB888);

			return image.rgbSwapped();
		}

		// 8-bit, 1 channel
		case CV_8UC1:
		{
		    QImage image(inMat.data,
				inMat.cols, inMat.rows,
				static_cast<int>(inMat.step),
				QImage::Format_Grayscale8);//Format_Alpha8 and Format_Grayscale8 were added in Qt 5.5

			return image;
		}

		default:
			break;
		}

		return QImage();
	}

	//将Mat转化为QPixmap
	QPixmap cvMatToQPixmap(const cv::Mat &inMat)
	{
		return QPixmap::fromImage(cvMatToQImage(inMat));
	}

	//将QImage转化为Mat
	cv::Mat QImageToCvMat(const QImage &inImage, bool inCloneImageData = true)
	{
		switch (inImage.format())
		{
			// 8-bit, 4 channel
		case QImage::Format_ARGB32:
		case QImage::Format_ARGB32_Premultiplied:
		{
			cv::Mat  mat(inImage.height(), inImage.width(),
				CV_8UC4,
				const_cast<uchar*>(inImage.bits()),
				static_cast<size_t>(inImage.bytesPerLine())
			);

			return (inCloneImageData ? mat.clone() : mat);
		}

		// 8-bit, 3 channel
		case QImage::Format_RGB32:
		case QImage::Format_RGB888:
		{
			QImage   swapped = inImage;

			if (inImage.format() == QImage::Format_RGB32)
			{
				swapped = swapped.convertToFormat(QImage::Format_RGB888);
			}

			swapped = swapped.rgbSwapped();

			return cv::Mat(swapped.height(), swapped.width(),
				CV_8UC3,
				const_cast<uchar*>(swapped.bits()),
				static_cast<size_t>(swapped.bytesPerLine())
			).clone();
		}

		// 8-bit, 1 channel
		case QImage::Format_Indexed8:
		{
			cv::Mat  mat(inImage.height(), inImage.width(),
				CV_8UC1,
				const_cast<uchar*>(inImage.bits()),
				static_cast<size_t>(inImage.bytesPerLine())
			);

			return (inCloneImageData ? mat.clone() : mat);
		}

		default:
			break;
		}

		return cv::Mat();
	}

	//将QPixmap转化为Mat
	cv::Mat QPixmapToCvMat(const QPixmap &inPixmap, bool inCloneImageData = true)
	{
		return QImageToCvMat(inPixmap.toImage(), inCloneImageData);
	}
}