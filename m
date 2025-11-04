Received: from smtpout-04.galae.net (smtpout-04.galae.net [185.171.202.116])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7BB306489
	for <linux-trace-devel@vger.kernel.org>; Tue,  4 Nov 2025 08:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.171.202.116
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762245912; cv=none; b=X5WgpNiyd38ayBG94rraVKi36P7OPfy+22jWaAjPj3OzEMJuJeS+/WxlIfoSCTWK9TC9Gpo2xIWJ2aE4IRGgHDvC6nWK7u2QoqrRNcV3oVuCeMI1ufCEqCuuHTK1WlZ5QTN/1gti75yES0VciheWzIOlG+KO50gg/3mEeYj4JPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762245912; c=relaxed/simple;
	bh=MYcK23z+tbgUZzeK8j9bgN/f5oR/GjmXMgqRHymTTD0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=FluQVVdZeRMvTZdrZNRh/1tH5Bwqj7ryrMcdHKdMTs1sJmGS8VmcRReZ0df11WByNUmWuqDG8UmFzAdblH3F175Icy7psKv4JnM6sqzImMOZhig7lRg+WLvCILkhV+ICKcZstCjrbNejn3nZ+45slljPvdw/xoqoymOj30oDw5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com; spf=pass smtp.mailfrom=bootlin.com; dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b=sD9wOQ9l; arc=none smtp.client-ip=185.171.202.116
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="sD9wOQ9l"
Received: from smtpout-01.galae.net (smtpout-01.galae.net [212.83.139.233])
	by smtpout-04.galae.net (Postfix) with ESMTPS id 29DF9C0E605
	for <linux-trace-devel@vger.kernel.org>; Tue,  4 Nov 2025 08:44:41 +0000 (UTC)
Received: from mail.galae.net (mail.galae.net [212.83.136.155])
	by smtpout-01.galae.net (Postfix) with ESMTPS id 0C6B9606EF
	for <linux-trace-devel@vger.kernel.org>; Tue,  4 Nov 2025 08:45:02 +0000 (UTC)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 350BB10B500CA;
	Tue,  4 Nov 2025 09:45:01 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=dkim;
	t=1762245901; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding; bh=0lrOmYnTUBsCOxpvWByiSQWpCXMGzp3x0c+HrRSEBgI=;
	b=sD9wOQ9lL4Bc4ih3O05/IyGbvwgCn5kQqp5p+ubIH3U+Lat+C22dHVHl7KOXd4Cjn2ou5D
	Bg/3kXKJ5XIyWLwLYXT/E7uvuXZuF9EvTRh8fYmd7+AkEvyPJqvN2TlokE3FoL7bh3sY+b
	A/wfHZGByjmkhnMjZ3ihzQS6aKqRowXgcpL1QOYgxc7t+HIfn07FL52WsGxA2B0rMVnnRK
	5lPkfXm2lVXSjfd7T9jExvZ7h6/dGO7yOZTfFNXorc8NQt+zXe9r/rUDz61J9E96v5R/Ev
	+RHclSGcvDavx+UordRtB6EYaXI1FNwD/kkTVafHVNdiFa9i1Li1mphaLNCohQ==
From: Bastien Curutchet <bastien.curutchet@bootlin.com>
Date: Tue, 04 Nov 2025 09:45:00 +0100
Subject: [PATCH] kbuffer: fix endianness flags for big-endian host
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251104-fix-parse-v1-1-5af9b8965886@bootlin.com>
X-B4-Tracking: v=1; b=H4sIAAu9CWkC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI1NDAyML3bTMCt2CxKLiVF1zY0vTRAtTc8MkcyMloPqColSgJNis6NjaWgC
 OUKdJWwAAAA==
X-Change-ID: 20251028-fix-parse-7395a8571b72
To: linux-trace-devel@vger.kernel.org
Cc: Thomas Petazzoni <thomas.petazzoni@bootlin.com>, 
 Bastien Curutchet <bastien.curutchet@bootlin.com>
X-Mailer: b4 0.14.2
X-Last-TLS-Session-Version: TLSv1.3

When KBUFFER_ENDIAN_SAME_AS_HOST is set on a big-endian host, the
KBUFFER_FL_BIG_ENDIAN flag is added to the local flags variable instead
of the kbuf->flags. Since the local flags variable has already been
copied to kbuf->flags at that time, the KBUFFER_FL_BIG_ENDIAN flag is
lost when we leave the function.

Add KBUFFER_FL_BIG_ENDIAN to the kbuf->flags when
KBUFFER_ENDIAN_SAME_AS_HOST is used on a big-endian host.

Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
Fixes: 5f2aa8497c5b ("libtraceevent kbuffer: Add SAME_AS_HOST for endian and size")
---
 src/kbuffer-parse.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/kbuffer-parse.c b/src/kbuffer-parse.c
index 71291adf0860b8392e6cfa0b0640c6472def422c..232d1688934a946e19f52886c2d25e4c73637b4c 100644
--- a/src/kbuffer-parse.c
+++ b/src/kbuffer-parse.c
@@ -247,7 +247,7 @@ kbuffer_alloc(enum kbuffer_long_size size, enum kbuffer_endian endian)
 
 	if (host_is_bigendian()) {
 		if (endian == KBUFFER_ENDIAN_SAME_AS_HOST)
-			flags |= KBUFFER_FL_BIG_ENDIAN;
+			kbuf->flags |= KBUFFER_FL_BIG_ENDIAN;
 		kbuf->flags |= KBUFFER_FL_HOST_BIG_ENDIAN;
 	}
 

---
base-commit: b3f5849527ae226b88342ef80fc42c66ab206f99
change-id: 20251028-fix-parse-7395a8571b72

Best regards,
-- 
Bastien Curutchet <bastien.curutchet@bootlin.com>

