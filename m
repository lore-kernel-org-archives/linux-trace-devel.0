Received: from sonic304-22.consmr.mail.ne1.yahoo.com (sonic304-22.consmr.mail.ne1.yahoo.com [66.163.191.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57322D9EEF
	for <linux-trace-devel@vger.kernel.org>; Mon, 20 Oct 2025 20:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.191.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760990490; cv=none; b=Kqsu51hTaWRjfkRkviBOfyqsSw6a7GwXseBA+eN8kSMTuOqRXNlBdGF3kFssLEaJOCU+radng0BKBcRrnSf0drGsZ9O1arH58LRlUvxrvOE6/6as4eKmz4vXS/Lq3MoaPurX5QhBHUrnRfFDkH8jPc772VsPc5UsWcZJ7YVKgZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760990490; c=relaxed/simple;
	bh=Sg8PZZYc8AQ9lyaKe/NDJ8BDcJlXmdGaoyUnctbAdrQ=;
	h=Message-ID:Date:MIME-Version:Cc:From:Subject:To:Content-Type:
	 References; b=WFxI50CJgUJPOWuPJCISKUTRadU6cPulS+50dvTAQJOtAP8Z+9zm3PovcGVTKvfMRcxb/z9HhJ4Hf3vn5vrGsEG4aFkHJVCK0J+yIUD0dJ4KybCGYEZ9Hz/JbiTmZ/UZc7aNtMtX3ReRyJNNgeAvNk0pABedumkRRAoePEU8dzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com; spf=pass smtp.mailfrom=yahoo.com; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=m93b7N8A; arc=none smtp.client-ip=66.163.191.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="m93b7N8A"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1760990487; bh=RCUdOpe/0rwXajVZfeFGEdIHJe/91qYwdTDjBNN7c5c=; h=Date:Cc:From:Subject:To:References:From:Subject:Reply-To; b=m93b7N8AHPjcA0byMpt6tSmjjrPNKIkUElfAkcFkp+l+OJH4j/e5kaBTcxpFIfv4yDRGT4s74bK4dK4In22MySuOo+gotddNM4L9EAvCoVAq7j+yaFo3z+N/p/t5O9S91laQzTO4Ud+cbSXa3OR+aYBzqullaQh5skn+3kOASwVz+419nJtmbvTMFn3wY4047eSpbRj6jWYCfKwiLz75MtPmXvrH2pHbQcsR1cLtS2tUrUbADMM/3D1MUPUG+bMSkN21+5Dup+cDsSIiu7s/0ZPhfHgCK0psI349nhTejH6qZLkXPhiTvwIYrQEL0yW3sfndkbUQgSKSk05ml/8new==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1760990487; bh=rv3edXRyRzKX9TmRcJOyAcs8mewtHVUgibuJiOh5EbZ=; h=X-Sonic-MF:Date:From:Subject:To:From:Subject; b=NwPnlZJkfyub2jNa5spUzfdTRedCx/VpWb9FeA3nUdrGqr20Iv8aPVKzkI+S49sOvSfhOM30fZTYWlsRQ5ZegC9oCMrcwqb13L0j+96OIkgc84jtWNGmdP7jMpUYZyRPi7H3p30ZYEpwZ5T/0iBzmJ6Ze75Ka7uws7Q0V2tT97RYofJCRM+T0Uyq5RLjjH4yt0wGhyyudB/osaseMaxBglZkEm+JxWPrHQDXH69VgRZs/h7sx48ve7ZEibiGeA7yZW37Syfj+PK6BrZMYmr2AesJ4fv52PJBDCQg3dP2aSc/yqOONd+6LoZ5ZOc26tteaaw7qyHFnKxobHnitKkG+Q==
X-YMail-OSG: V..uHOwVM1noC894VFtMD3ndGgr7mwg.xbDWmQOYWGTkrrkQROuKkvNYDsw03NY
 MMZ.T9IabpJouJlQGsnJ.MjAfPGPAdkICfKq31vQKYro0KBcaK6NZ7hyxuXT3IHwH_BKqHezs2iL
 qAlT8qj.axBzqMc0tcrqEcWCLkhSgWHZvB1gN60ABoQjCCE.GX4u4s1T9DGM8B2w1wlgZemwuECV
 pUUym5_K0.s1jPA83iaaAQP5RD.iopELSSLzymDI1bDkz.KoBVowcx0oqXcEOrVDWd.Kllpy_mQZ
 HNN.2i7Iq4N_Qkr_M1mYXei6RwUOPGzFDW5BxkLY72oDNskJC6KwoFhL9.nzmgr6YYIRHNGvX2bb
 YxJzPvxJMYWOG287EzEQGZA7.O5_kRg8KFoH1_lLW7y3FCs1zC0gntic0NaGMCOHX0bF92GQkbpV
 gGPd5NsHxlQueFiRg3EzXAI8iWNQdgM5gPbJhAsO6JWfE6JxSKDwjbIZfuGr6XFRXuEHwCBFb8vz
 yxyFVWlzvCCcZT3ROCVxZrJAW9wbtkx9v8LIw7vYneqUKmnMybyV7kxOJzc47cMKRuRJ6F58oA_M
 lvNwgle69p1c_5N6p0eX9B36aPsNXJW4E7F2BFGS0HL8NTKTWFFF0X1J1Ny3IGxiA8.GkndJUGyW
 OwXqwN4L09YtZKMzUH28xAKAQxAG5Y4n3mdxoshUcMaCqPWieNP8II9s83IZB.zp5J9uOWTIcWCu
 CZAF3Xv7rpUpocQ7ShVTNhN7U9lPxcKMXv8s0ArY8PV0iiq2bEGeXK38uJHKSp30Eed8_iSAi5aS
 UaCGO2NpGF2tLt3Aa.v96psPyds77xDHl6IK5t1iuMqbNcWH7ZUrawb3vtCKY0kK2zV3VRrgyf_I
 ICL.LHgq6dpuvqHEYcOoJQtZqe4czf96MQV_OMjgw6YwRtELXDEtiS3XcpFN0f2w8tYxpb86Gt2Y
 I5H7K7E8qFkJW0dJJmchOS0tZgeWw5YPHMyYA6dHYrrE4cNL9D82s7.YOVmcL1YsfE6MAC8hh.WJ
 YI4h3DDTPAqsYlxcoBRz66RbTz_4Z3egLDRgAayzAqEifiYkEZZWBgWlFZzeMgMkdc5QUsMBCtZx
 g6N8pjG54amI4Y3I1z8S9DByXccrys2k01jDsoGpTBxF0a3.0c4Aj8f5bVxOzHlFGIKB1Lhjj.f6
 GnUecu2OpEV4MFLFDdX5L9nCOeSn2Ux.v0KwCcVpT43po.uACcA8o68so0wk7KrJqFDPQc_4B2v8
 LtYSHCZx5T8xVByaW9x3mOTBXRNIeEgqVvLjvT6hFWxlWPMbhYNd8eJZRxOlfiWTi6qJpS5qZpJM
 U0oWckElsoxyJgAmlEWBMJ.WHpFMGurjX2wOKCovhIiF1hqPpjBw5JvKWKsiaWfZqbc.fkI9QI7T
 qDivh.AtbuZgJ469uSs_o9RI5QdNKlJEtU995WUz5dT3_pRKnfovbUCVmFKdtxwTwrPO593DXf_X
 4Whaoy6RyuWpJqEiQPqVYrSnay.ePFi7iqvs61X0g6n7IA0k0Iog7FxmsHv4FI593U8jbHNDjJ.l
 69N1vLJ18hl24UEp6ql8EDGZmtBv_DIDWv_O5b3sppaBI0XG8PUfLpwTtfHS9LqUmmO1.27MCjnV
 xyZjUtdS_UsLuOnpd0.5yOorchtI4Gq46cJIC0Gxj9NmFKKp3gUKIEOB59wECo_OZFxic2iYyejq
 6.4Ol8YN5IwFJGnMbQOs5Cjpny3EL.MQUwnZ7CBlx84ZNUfRmhgmMK4rRgxYmCVjV07Wq8OXtk3W
 DkxOdrpnaImXc1Oo7okL1x8SpwvNVj6TtfkAVqFwxZsudMAH2EOLqvSo0bBAAmiGtdq8moMbk.F_
 UNxy2oE9Svt5yAhhKIs0RltflA4pK2rbpfnZynIlY3qOaFfCF1b1S1QXmW_SGl0VAOWB6focTrId
 beyr36LXcizuENNBFrCSwa4tcdqwbvYHs6kSjOHlf6k1QOXiCMrIZpwjyje2M13p5ccm7.N.kWMz
 EQulw5kOw2X3yvwtg3m9nfAPyGpborTep65ZHKt6Y.UodcxVDPum5IialE9t9b1efi48nC7m0VDH
 GgSmmi5FhHjxIeYygH3eS9N.rcTPQ7ODNjGRph3bi2adsBRaqOEStEnFqNU.Oo6d.VPcIGDt9p6I
 wOnDr3BaJtKIFXXkwyJLCC8E90laO.r_CtFSv_QOq_bSb4_TjdBGp1IeSO5DV5HqelYupgpIpy_b
 v9_Qm2AYl_nNlU5G_Fr5CGfiAOG_i6qWEiUKQJx3Ygxb2xoVtsU2FIE3QRbpigUvcOB8Y
X-Sonic-MF: <mircea.cirjaliu@yahoo.com>
X-Sonic-ID: 813b775c-13d7-441e-bce1-3cf427a81109
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.ne1.yahoo.com with HTTP; Mon, 20 Oct 2025 20:01:27 +0000
Received: by hermes--production-ir2-cdb597784-2m72n (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID e13d244d90496e30698b0378da53ef63;
          Mon, 20 Oct 2025 19:00:43 +0000 (UTC)
Message-ID: <5c7a78ce-b1f6-4396-982a-8b884242d8cc@yahoo.com>
Date: Mon, 20 Oct 2025 21:00:41 +0200
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
Cc: y.karadz@gmail.com
From: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
Subject: [PATCH] kernelshark: fix bug in the behavior of ksglwidget rubber
 band
To: linux-trace-devel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <5c7a78ce-b1f6-4396-982a-8b884242d8cc.ref@yahoo.com>
X-Mailer: WebService/1.1.24562 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo

Accidentally pressing right mouse button while dragging
the range will cause the rubber band to behave abnormally.
Improved the logic behind range dragging to account for this case.
The state of the rubber band will be reset on right click.

Signed-off-by: Mircea Cirjaliu <mircea.cirjaliu@yahoo.com>
---
 src/KsGLWidget.cpp | 40 +++++++++++++++++++++++++++-------------
 src/KsGLWidget.hpp |  2 ++
 2 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/src/KsGLWidget.cpp b/src/KsGLWidget.cpp
index 7f2001c..a2c1fc8 100644
--- a/src/KsGLWidget.cpp
+++ b/src/KsGLWidget.cpp
@@ -190,6 +190,9 @@ void KsGLWidget::mousePressEvent(QMouseEvent *event)
 	if (event->button() == Qt::LeftButton) {
 		_posMousePress = _posInRange(event->pos().x());
 		_rangeBoundInit(_posMousePress);
+	} else if (event->button() == Qt::RightButton) {
+		if (_rubberBand.isVisible())
+			_rangeBoundCancel();
 	}
 }
 
@@ -262,8 +265,10 @@ void KsGLWidget::mouseMoveEvent(QMouseEvent *event)
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
@@ -291,17 +296,20 @@ void KsGLWidget::mouseReleaseEvent(QMouseEvent *event)
 		return;
 
 	if (event->button() == Qt::LeftButton) {
-		size_t posMouseRel = _posInRange(event->pos().x());
-		int min, max;
-		if (_posMousePress < posMouseRel) {
-			min = _posMousePress - _bin0Offset();
-			max = posMouseRel - _bin0Offset();
-		} else {
-			max = _posMousePress - _bin0Offset();
-			min = posMouseRel - _bin0Offset();
-		}
+		if (_rubberBand.isVisible()) {
+			size_t posMouseRel = _posInRange(event->pos().x());
+
+			int min, max;
+			if (_posMousePress < posMouseRel) {
+				min = _posMousePress - _bin0Offset();
+				max = posMouseRel - _bin0Offset();
+			} else {
+				max = _posMousePress - _bin0Offset();
+				min = posMouseRel - _bin0Offset();
+			}
 
-		_rangeChanged(min, max);
+			_rangeChanged(min, max);
+		}
 	}
 }
 
@@ -1132,7 +1140,7 @@ void KsGLWidget::_rangeChanged(int binMin, int binMax)
 	/* The rubber band is no longer needed. Make it invisible. */
 	_rubberBand.hide();
 
-	if ( (binMax - binMin) < 4) {
+	if ((binMax - binMin) < 4) {
 		/* Most likely this is an accidental click. Do nothing. */
 		return;
 	}
@@ -1182,6 +1190,12 @@ void KsGLWidget::_rangeChanged(int binMin, int binMax)
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

