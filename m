Received: from sonic308-9.consmr.mail.ne1.yahoo.com (sonic308-9.consmr.mail.ne1.yahoo.com [66.163.187.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 078B31E47C5
	for <linux-trace-devel@vger.kernel.org>; Tue, 28 Oct 2025 20:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.187.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761684339; cv=none; b=cXYcGMCXV1Ji5n8+JDF5ZTTX4XonoWMSQH9uMpnLhdW1qQch61ST41pr9b5fCaRKM2wFMEZPMPZf0UBE1qceL63MgaVzSgTTcyMdZYGPg2wByV1sr5rfN4SgRDVP2PatAZs33fDqmcTuOJm9Tr+JKo55F1ojr9dydv4gUQM7X/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761684339; c=relaxed/simple;
	bh=dsq13kztmSIftRMZ65MfCjiaDmlOcr3AbMqU6iw/tJg=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type:
	 References; b=ko3JWZuL0WrLwnp8/XX5C6dGqk9cV2+gbVTaezlE8Y/ZFLZagO9DHsvUxgolExOPLZaKQFpIAVgobCSN85VzuXu1H/F8yOMMvx9jcAxClzx+ksmbuzj0z2ux6pmlRtEhK+5wY7kASGQRVf2aNOFsolI++6lM7EFksl2eu94rL3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=BfnRroNb; arc=none smtp.client-ip=66.163.187.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="BfnRroNb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1761684331; bh=IW44A5nymgr1DZglslO6imO7kZ/2nkbW4xKwrPH8D20=; h=Date:To:Cc:From:Subject:References:From:Subject:Reply-To; b=BfnRroNbAK3GTpl6fXjYuAE/RK3bs4QIBudwra7UINraZewl2BxIqXDur5L61G0sN3GW85iNoY3uLQDUBnldEE4Mdj5Lu7qdWULvgVsvsi+lnnjLSaHOBI2m36cmPozO6eHHjFqOYVyKTLPAauiwBubZQ4ZmRsl7XYRpPZ5QI5cBIXTYqA/YgU3rR+5SaZYNiDbrslkxg2vEGtYEyTOyCqvIQFRjePAmoyexQC1OqKUHKBrt81w81mNWUiiFguuzKJFTPK0K9rbSLhQp9BduJQxv9AyqIpYY781bQcrf0s3RQyxZRxiH5b27Gfs/2JxSiExP8HUeWqBWVLLnbnhTOw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1761684331; bh=mvqlKNPmcoOyrlMFUG2FVx3xcy0Jk7FHkztZ7qHG+CV=; h=X-Sonic-MF:Date:To:From:Subject:From:Subject; b=K/iW09j2XAzPcD6Ox8vM5Ap+bwAq73Mn890T3B+p0deq7Na0PzhtDefKCMbxk/6hyVQ825lcQ3qED/yP+eRG7qU00TizbBIk5arvgH1N6GBnti9ChdJodyRRXAJpKjfm78zHOm8S3L8Yzs0/+xyVzSs8hT3scY8NEP8ODsv0noSnEMHzo0gViv5+xucDCz+FbNgrZxNxwVykXO2A71DeWaxcmbBmEyoE3UlJMRg4VGjnQg5wvT18DtY3+I6biRELrDWNAtelyhfj814n2ZFKwalvsIaVas5WJy9OP4E9+0JXU2PkO236RxH41q2RLXJqQsQR87azk/j+KCoTBkS9sQ==
X-YMail-OSG: HmJHGngVM1nwgW9g49oBKcYKmOzM7mEG5kvDmhRX5BTKLkbyOlSiPBDCx1DpOFt
 K6J0cIo.2lTkyLvYY6mnbXnjuken2QCS5BKi6beWMIJk2kqCf6.PcUcH5G2bfu8a_hNd5v5XQhw8
 g_dbKgZwiWucw6pRzKAWuE3vZKmnTBu9NQoMbrCvklbwtpCaXSkWwkkB7aYucLqC6C1zeAYWQDiI
 50jvMkJrmdfxHHoxPfW4b6dRr6tqdVsBGgywb5eYndpUCpwaad2iQgUH_2E8gOrMuOi4tHIMkS50
 jUeEP33fGiK.wgnBii2_d9FlIf2jusP2ufPehMG_.OYdiG9LaIT7Gc19AMpPES1ZSQ34sNCCxFsN
 ne4265otXA2Xjt7muuwhvzDvDPRDcsyxWwy9Prup4PYcGqAdqoPtHwvV_UU2dQg9fvQupDoXypFL
 Qj_gajuEYmPeE1C7Ggw62mHTXFlKjrRDxhIuLmkm8NWrYPE.RodhYsZAc6QUb8_k0xGequ6444aN
 cZhxEfl7hhIL7IBg7Y_1R0donzUZtfExu42sf..OoED6YFZeTamV5VonjqTJBB7Ua.n5oNTDItKr
 cEtNOTMe3yYdvzT1dxD_HUOVEryUOKme.x3IdrPFfJioMjI4CQeFcqGcZLWl.6EMZtDyjsXe.W.5
 1iR8Yk3Mpc1O8pA3ia.2xgjldaTey9hERZaGmEhXac_qJvTW0wJD3NDhTapQ4xQJzSJIiOmtIoNU
 57gCxbx8ci.Pn8K_Htz_zukqSeGyABop1umo6aV8BjcQhUVcFuEgTJr3eC7XMCO8Oa9Iq.0cPj.t
 Gu7EHDArDD8vE.YWNrS2bDD3.uq.5zBetly5Tby26XAg4o4Hf6b1fPBiSPFJd8gzhddiIq_5JCXt
 ZeSsYooTyHUROSdycaRbYtfCuITYqjHDqGNZBlyvWp9HiAtOrhhsHEMUum8NdEPa.M5yg5h4ijAx
 SGcbbCxZwQruHEBzrIEVv59laf8W4JY0G._gRP1StT_XjJd.qy0vRJkF1QUZH7ZUCeOeyZ_0Zoil
 yF6BCuSulqA.GAP_wxKyKjlAhYqnQPmJcjf_c6hrJ10r7sgci6i_N9.URgL1E6k1oC58qzIzJHqu
 oO1ulxsPZ7sCZwNL0EdI5EKz2nCFpXhu6tjLqpe8atM4kRxgVzQmjC1XjoGhbc1OMek6yTG1EGpA
 WSjBRvycwSIZchonZ0DLl.BFPjrm6YkxEBrIeJFxv_witEgLZNXtEffYT3f_gOOJpm_ZDvwX8Wi5
 _2WDk6QU1uJJn1sYxmOIcPtG8X6mWx4t0bqTVv1lsfOTL962_V75ae9j3DI0uC8VquEAWIyhn374
 o.BYYJf.AkMFpPA1qXSkVtYVoOoOT8RMWvfDDRn0NaIjZTE9PVVDvka7YbuCEEVIU9kfP6ucUkmt
 swG41SjHEVGaLYO_NZSc3F5CM.bQ62VrMz4RN0hn_Q3mBYNxzGvigp27Sgs64HzNshpvsgMGm0uZ
 84UIe9I8FQl7PwpDsrEQSaYhj_3a26AyHPU8UZdT6TlR5X3t7tot1pROOy3whQmH18D9Ru4wnZS7
 mcglpEDSmByccsHPOGLfUvvvzeQf46GLM8pBKYYrrQZzTo7jseeWHxQis_EqyHxJrFz.mHv4yd1C
 uiC2Vt5yiboAId0k_c35fEnShzhsXKzE15G6S65qbpGT3BnyICJt524R4yaUzTjKWmEMGfaP4EdY
 Yp37S98ebGm7BdrtoLEa3wLKb4KsMvIlDHepwiDQDXpzo_LGcvS1yY6E3096OpFMjffF0wgni7vH
 57uSR2qJYp5B9juUuIyrdZ09i.XDbvljVjnLqVaO_bzBI7bCwhBsYwPgLiytC6Q4m5Jv2h1jYsZe
 r8Hv2rgnzStJ3AArVNjAtfgCMbYQnnD_cGE8xXaHlwM6A4Vw15jHhvYeX77tI1MnK8FtVKocldC8
 RugpPa3KDTbmLJ_JrMyv8HjyjMTjndgGl_MsNj3kQj59rmQMsgcA71hRWKEV9vM3fq9qUE9GHZzA
 VRPRdBI8xcbwDfKSSexfD8d7UFuBRZjHOGskQpvHHTLqTsGWMPjzS7y4it8QDJd_.oqxudFRyX5j
 6AUstKJPPoS1ohjhXe1P5wv.irSShrnMlUJNuBY2GWQbWSWziSe_v3vc8j2eN6cdrKNEHYWnUpP2
 2wh39Wb.gqarg1Fm5reO0u1SxZgHkMf4mC380IA30rVY.OPhsayjO.hJi72kxifTc5CHWlOYnfJf
 fwnksXPAY0IzlD4ikW5HX.lvC7rRgkK2mQMa4I.ofdLbDjPhaM9hrl93MKhSljnpZ4DspM7Xic3Y
 -
X-Sonic-MF: <mircea.cirjaliu@yahoo.com>
X-Sonic-ID: 8af386f1-e1e7-40ed-b732-4ad179bd7499
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Tue, 28 Oct 2025 20:45:31 +0000
Received: by hermes--production-ir2-8c47c9895-ljhdn (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 08fc98dcdd7aee730c5c9e8d83b45226;
          Tue, 28 Oct 2025 20:45:29 +0000 (UTC)
Message-ID: <7b5dc58b-f4c1-4b8d-a88b-72fe6d04399a@yahoo.com>
Date: Tue, 28 Oct 2025 21:45:27 +0100
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-trace-devel@vger.kernel.org
Cc: Yordan Karadzhov <y.karadz@gmail.com>
From: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
Subject: [PATCH v2] kernelshark: fix bug in the behavior of ksglwidget rubber
 band
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <7b5dc58b-f4c1-4b8d-a88b-72fe6d04399a.ref@yahoo.com>
X-Mailer: WebService/1.1.24652 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Accidentally pressing right mouse button while dragging
the range will cause the rubber band to behave abnormally.
Improved the logic behind range dragging to account for this case.
The state of the rubber band will be reset on right click.

Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
---
 src/KsGLWidget.cpp | 23 +++++++++++++++++++----
 src/KsGLWidget.hpp |  2 ++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 7f2001c..ea8cb93 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -187,9 +187,15 @@ void KsGLWidget::reset()
 /** Reimplemented event handler used to receive mouse press events. */
 void KsGLWidget::mousePressEvent(QMouseEvent *event)
 {
+	if (isEmpty())
+		return;
+
 	if (event->button() == Qt::LeftButton) {
 		_posMousePress = _posInRange(event->pos().x());
 		_rangeBoundInit(_posMousePress);
+	} else if (event->button() == Qt::RightButton) {
+		if (_rubberBand.isVisible())
+			_rangeBoundCancel();
 	}
 }
 
@@ -262,8 +268,10 @@ void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
 	if (isEmpty())
 		return;
 
-	if (_rubberBand.isVisible())
-		_rangeBoundStretched(_posInRange(event->pos().x()));
+	if (_rubberBand.isVisible()) {
+		size_t posMouseRel = _posInRange(event->pos().x());
+		_rangeBoundStretched(posMouseRel);
+	}
 
 	bin = event->pos().x() - _bin0Offset();
 	getPlotInfo(event->pos(), &sd, &cpu, &pid);
@@ -287,11 +295,12 @@ void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
 /** Reimplemented event handler used to receive mouse release events. */
 void KsGLWidget::mouseReleaseEvent(QMouseEvent *event)
 {
-	if (isEmpty())
+	if (isEmpty() || !_rubberBand.isVisible())
 		return;
 
 	if (event->button() == Qt::LeftButton) {
 		size_t posMouseRel = _posInRange(event->pos().x());
+
 		int min, max;
 		if (_posMousePress < posMouseRel) {
 			min = _posMousePress - _bin0Offset();
@@ -1132,7 +1141,7 @@ void KsGLWidget::_rangeChanged(int binMin, int binMax)
 	/* The rubber band is no longer needed. Make it invisible. */
 	_rubberBand.hide();
 
-	if ( (binMax - binMin) < 4) {
+	if ((binMax - binMin) < 4) {
 		/* Most likely this is an accidental click. Do nothing. */
 		return;
 	}
@@ -1182,6 +1191,12 @@ void KsGLWidget::_rangeChanged(int binMin, int binMax)
 	}
 }
 
+void KsGLWidget::_rangeBoundCancel()
+{
+	/* The rubber band is no longer needed. Make it invisible. */
+	_rubberBand.hide();
+}
+
 int KsGLWidget::_posInRange(int x)
 {
 	int posX;
diff --git a/src/KsGLWidget.hpp b/src/KsGLWidget.hpp
index cafc70b..8fcac55 100644
--- a/src/KsGLWidget.hpp
+++ b/src/KsGLWidget.hpp
@@ -315,6 +315,8 @@ private:
 
 	void _rangeChanged(int binMin, int binMax);
 
+	void _rangeBoundCancel();
+
 	bool _findAndSelect(QMouseEvent *event);
 
 	bool _find(int bin, int sd, int cpu, int pid,
-- 
2.43.0
