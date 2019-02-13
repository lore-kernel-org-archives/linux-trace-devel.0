Return-Path: <SRS0=ndxz=QU=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F748C282C2
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:13:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1452220700
	for <linux-trace-devel@archiver.kernel.org>; Wed, 13 Feb 2019 16:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404348AbfBMQNC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 13 Feb 2019 11:13:02 -0500
Received: from mail-wr1-f52.google.com ([209.85.221.52]:45777 "EHLO
        mail-wr1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404331AbfBMQNB (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 13 Feb 2019 11:13:01 -0500
Received: by mail-wr1-f52.google.com with SMTP id w17so3112815wrn.12
        for <linux-trace-devel@vger.kernel.org>; Wed, 13 Feb 2019 08:12:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=4djTplACkfBDOsPGPfdNEeN0GpPv52/DN+NCFC7S/uQ=;
        b=rv/hSvgsZtURvWbCEhSUH7Jo9NR2R+8S885Nrz3McMP+tEEkac7FG72ztN8VXhTxLz
         In/xHKIDY1Ybx1sargYGjz6ej3tD0ZO8a9jcYCN3LGGuGkNKp1HXcLgnAbXYQiXtcUj+
         CHzrEFsNotp1kaodpMSO7QgSagRZj8lnfRDnhd3XpWhnC236NsovP8K7EiUS9PWNkdx9
         hkZTkGNBZJh83szGBdY2snyIKJ8VwKeHHT1gs39kRCf9906T24FVQoCKMb63+flH0mY0
         kjHqVtTVf7da0lJXOQlfsZbQM4oFxdQkUpM1fMi8s2sjQapU6GJlt+F7CVi4mQddEM6I
         udrw==
X-Gm-Message-State: AHQUAuaiMBiHLP/uCu8iaV6RDM+WGdLl3CrX53DdpwYimhaU8pNBw6Kv
        DHFTdneH+4X+JjcMtAWN7GU=
X-Google-Smtp-Source: AHgI3IaYUWtctPvRW4ujYRHIms2q3gA0rWkO8XGg3d7KNmu3+W1FrmuElo0++d9ScUkuCV7VdLSsGw==
X-Received: by 2002:a5d:4145:: with SMTP id c5mr1024193wrq.256.1550074379105;
        Wed, 13 Feb 2019 08:12:59 -0800 (PST)
Received: from localhost.localdomain ([95.87.211.218])
        by smtp.gmail.com with ESMTPSA id h9sm3111631wrv.11.2019.02.13.08.12.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 13 Feb 2019 08:12:58 -0800 (PST)
From:   Yordan Karadzhov <ykaradzhov@vmware.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <ykaradzhov@vmware.com>
Subject: [PATCH 5/8] kernel-shark: Make the time labels of the marker more readable
Date:   Wed, 13 Feb 2019 18:12:13 +0200
Message-Id: <20190213161216.14438-6-ykaradzhov@vmware.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190213161216.14438-1-ykaradzhov@vmware.com>
References: <20190213161216.14438-1-ykaradzhov@vmware.com>
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The precision of the displayed time of the two markers is set to
1 microsecond (as in the table). In the same time the precision of
the time difference (Delta) is now 1 nanosecond, because we expect
that the user do not care that much about the absolute time of the
event, but may want to measure the interval between two events with
the highest possible precision. The displayed time is formatted
(spaces added) in a way that aims to make it easy to read the
milliseconds and the microseconds.

Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
---
 kernel-shark/src/KsDualMarker.cpp | 42 +++++++++++++++++++------------
 1 file changed, 26 insertions(+), 16 deletions(-)

diff --git a/kernel-shark/src/KsDualMarker.cpp b/kernel-shark/src/KsDualMarker.cpp
index 43bc177..5dcbaae 100644
--- a/kernel-shark/src/KsDualMarker.cpp
+++ b/kernel-shark/src/KsDualMarker.cpp
@@ -329,29 +329,39 @@ void KsDualMarkerSM::updateMarkers(const KsDataStore &data,
  */
 void KsDualMarkerSM::updateLabels()
 {
-	QString mark, delta;
+	char separator(' ');
+	int precision(6); // 1 microsecond precision.
+
+	auto lamSetTimeLabel = [&precision, &separator] (QLabel &l, int64_t t) {
+		QString time = KsUtils::Ts2String(t, precision);
+		int i = time.indexOf('.') + 4;
+
+		/* Insert separators for milliseconds amd microseconds. */
+		while (i < time.size()) {
+			time.insert(i, separator);
+			i = i + 4;
+		}
+
+		l.setText(time);
+	};
 
 	// Marker A
-	if (_markA._isSet) {
-		mark = KsUtils::Ts2String(_markA._ts, 7);
-		_labelMA.setText(mark);
-	} else {
-		_labelMA.setText("");
-	}
+	if (_markA._isSet)
+		lamSetTimeLabel(_labelMA, _markA._ts);
+	else
+		_labelMA.clear();
 
 	// Marker B
-	if (_markB._isSet) {
-		mark = KsUtils::Ts2String(_markB._ts, 7);
-		_labelMB.setText(mark);
-	} else {
-		_labelMB.setText("");
-	}
+	if (_markB._isSet)
+		lamSetTimeLabel(_labelMB, _markB._ts);
+	else
+		_labelMB.clear();
 
 	// Delta
 	if (_markA._isSet && _markB._isSet) {
-		delta = KsUtils::Ts2String(_markB._ts - _markA._ts, 7);
-		_labelDelta.setText(delta);
+		precision = 9; // 1 nanoseconds precision.
+		lamSetTimeLabel(_labelDelta, _markB._ts - _markA._ts);
 	} else {
-		_labelDelta.setText("");
+		_labelDelta.clear();
 	}
 }
-- 
2.17.1

