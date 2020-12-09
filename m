Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 024C2C1B0E3
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:47:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD1A123B52
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732415AbgLINr2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732440AbgLINr2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:47:28 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8E6C0613CF
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:15 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c1so1798579wrq.6
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZmP1cMwJams9Qph5p5JmU94mt6kQfjBZBdjETGroLAw=;
        b=YREeQRQJCTKSfKUpfakSbwdFuDQQPMvyerdV/dOjpRq/DjxSt3u2UialKhXy0weFD3
         yGlD1YWon+JdNRj1ahZ2S9xCS9TLbe7uCB4Zbl8ptdfOMKW612c9X0EgBCk/sYoibv7k
         KKejIZWWcL7ZQK1RVOr1JrkJmjDrEZVayodIYAj6JeU2VDkTXtcgKHkadsoamgpc1vVR
         2zhbGSq3x+R1Q5Wsu8OTMbZdFQ9g1iKgfEhAvWO3y/u7EToYELp8gnhkwHQ5gAcXEjxZ
         wzViJ97Yxm+cW6faCR/rtT4IcjHyCZzXzwY76ZneQGT+tnb5RgwY6eeDA2cXAok75K8l
         B8pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmP1cMwJams9Qph5p5JmU94mt6kQfjBZBdjETGroLAw=;
        b=EGSskB05gtnFnxirVQy5xSq5EDqFZV5JKnNRCFXVjwaEE1avb0fKhfxj9J7Bm3j8xo
         nQpRzZfmM9Faimoy+5qcsDyeW1QFuHZ2/vTq8O30wv7uhOHTwV8dvLzZzoctAITsG+D0
         RfCjiVIheNeoIl+FTys0U4crdjzM0Ia4NY+eFkT8BrGlHL9rly+csqf3COP2DQgvTxbb
         SmLhwI3W9YSdKokJdaQUV55s2JrPB1jR6SFD6t/4JG0/CafG4npTigO2tttwuOQrKTbc
         rVLum1URgbcUyk9yzKVtvGw5bgWsblaUT/+KxXBfOqKeY/wN3q4YmDEx81pZWue7D8Hj
         wjlg==
X-Gm-Message-State: AOAM5301E46dGugaplOy1h0RFfmMXN9u/R7Psz/9tX6tt+s6jhZ8dmdG
        R2qPu3YvMOvcLuEtVB7fff4=
X-Google-Smtp-Source: ABdhPJx5eQ27pYiX670BdgQM9Lt972n+7ofHCniX7RcJYjY9pPcApSpUm9ziUFD9/weQL3QdeABv6w==
X-Received: by 2002:adf:9546:: with SMTP id 64mr2818657wrs.343.1607521574655;
        Wed, 09 Dec 2020 05:46:14 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:14 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 09/10] kernel-shark: Add VirtBridge and VirtGap classes
Date:   Wed,  9 Dec 2020 15:45:29 +0200
Message-Id: <20201209134530.428368-10-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134530.428368-1-y.karadz@gmail.com>
References: <20201209134530.428368-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

The two simple plotting classes will be used to visualise the
guest->host data correlations.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 22 +++++++++++++++++++++
 src/KsPlotTools.hpp | 47 +++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index 9f98386..8d38009 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -1460,4 +1460,26 @@ void Graph::draw(float size)
 	}
 }
 
+void VirtGap::_draw(const Color &col, float size) const
+{
+	if (_entryPoint.x() - _exitPoint.x() < 4)
+		return;
+
+	Point p0(_exitPoint.x() + _size, _exitPoint.y());
+	Point p1(_exitPoint.x() + _size, _exitPoint.y() - _height);
+	Point p2(_entryPoint.x() - _size , _entryPoint.y());
+	Point p3(_entryPoint.x() - _size , _entryPoint.y() - _height);
+
+	Rectangle g;
+
+	g.setPoint(0, p0);
+	g.setPoint(1, p1);
+	g.setPoint(2, p2);
+	g.setPoint(3, p3);
+
+	g._color = {255, 255, 255}; // The virt. gap is always white.
+	g.setFill(false);
+	g.draw();
+}
+
 } // KsPlot
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index 4a7ca0a..b9b93f3 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -578,6 +578,53 @@ private:
 	int	_firstBinOffset();
 };
 
+/**
+ * This class represents the graphical element visualizing how the execution
+ * goes from the host to the guest and back.
+ */
+class VirtBridge : public Polyline {
+public:
+	/** Create a default VirtBridge. */
+	VirtBridge() : Polyline(4) {}
+
+	/* Keep this destructor virtual. */
+	virtual ~VirtBridge() {}
+
+	/** Set the coordinates of the EntryHost point of the VirtBridge. */
+	void setEntryHost(int x, int y) {setPoint(0, x, y);}
+
+	/** Set the coordinates of the EntryGuest point of the VirtBridge. */
+	void setEntryGuest(int x, int y) {setPoint(1, x, y);}
+
+	/** Set the coordinates of the ExitGuest point of the VirtBridge. */
+	void setExitGuest(int x, int y) {setPoint(2, x, y);}
+
+	/** Set the coordinates of the ExitHost point of the VirtBridge. */
+	void setExitHost(int x, int y) {setPoint(3, x, y);}
+};
+
+/**
+ * This class represents the graphical element visualizing the time interval
+ * in the guest during which the execution has been returned to the host.
+ */
+class VirtGap : public Shape {
+public:
+	/** Create a VirtGap with height "h". */
+	VirtGap(int h) :_height(h) {}
+
+	/**  The point where the execution exits the VM. */
+	Point _exitPoint;
+
+	/** The point where the execution enters the VM. */
+	Point _entryPoint;
+
+private:
+	/** The vertical size (height) of the graphical element. */
+	int _height;
+
+	void _draw(const Color &col, float size) const;
+};
+
 }; // KsPlot
 
 #endif  /* _KS_PLOT_TOOLS_H */
-- 
2.25.1

