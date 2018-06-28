#ifndef PIXTRANS_H
#define PIXTRANS_H

#include <opencv2/core.hpp>
#include <QDialog>

namespace qtcv
{
	QImage  cvMatToQImage(const cv::Mat &inMat);
	QPixmap cvMatToQPixmap(const cv::Mat &inMat);
	cv::Mat QImageToCvMat(const QImage &inImage, bool inCloneImageData);
	cv::Mat QPixmapToCvMat(const QPixmap &inPixmap, bool inCloneImageData);
}

#endif