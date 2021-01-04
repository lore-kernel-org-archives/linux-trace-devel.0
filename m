Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FDCC4332D
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43AF9206B2
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbhADRtf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727310AbhADRte (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 12:49:34 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 674C1C061342
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Jan 2021 09:48:21 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id q22so37960323eja.2
        for <linux-trace-devel@vger.kernel.org>; Mon, 04 Jan 2021 09:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZmP1cMwJams9Qph5p5JmU94mt6kQfjBZBdjETGroLAw=;
        b=TOnwION65do4Lfzc507R671yOfo1LWEELVayH4KC75UvC1ZLswsEWDG7mqtiefSh6t
         x+Xw2a2uB6gMleAl2mAExpq+458ET52udWDsmz4iOZWdhLAK3BrcePSdLrlErZmW0FQv
         xeyY2G2/F8An+cYUGV4qcJTvkYafnWdTY0As7X1TUcfusJ+ulQShdfL6A26qdn+eazv1
         RB7qAP5be0rK11/R3ujEXMnHoaDGiT8r05L8Xn8KXkOVnTvG8IIEwfwVyGPBEIe35MpM
         kgObyEmqaPT0PJ+YeIUgOVFr8TN6SKfYntAUB1Tl0sMMYdJxk1qk0d/KgmAX+F5bPbOY
         SoOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZmP1cMwJams9Qph5p5JmU94mt6kQfjBZBdjETGroLAw=;
        b=D0nLke4/SaNtL5/RjYD4wAg5ZE7u5+BE2slGUdOqXxb26unQ3kEbD8/hIzYNUuRr7t
         ZuLSZm4NDV4HXb1Vgy00OZWpIG8I3IVk6+ABd9Va9YHVn8jT8cFhCoWmuK8ICRKKS37L
         3LbDgUhIO4o0hfnA5BansJMz46Nz3psdqscJ0j+wx8IhcdsXk5n5KfkHO53X3eMY7bsc
         Mdrl7t3Nefkz4jpPX2C34TBGUC3pjo+U7Fqr6St/HIiTic6gMBWlDU9+85X8WMvQgLWN
         P4gjXVis51zwUIjFqvY7nbnZCOFNR9vYgCSZO5GRbPlxPZQwymzKNTrp5xzqQjDAbQGF
         +LFg==
X-Gm-Message-State: AOAM5318X2ta9VkRlaC9UUsxkc6iWF2xlDIzMB8DWQ9FdP0fULrw4VhP
        n1Z+bxhLoXB+PtowL5fVT/M=
X-Google-Smtp-Source: ABdhPJwz+l4B4Hr9LUqphY9CnXe+twdJrclh7GXnweTvca/ejtPffXrSBrarv/HneAvzaTGcSUXhsg==
X-Received: by 2002:a17:906:8255:: with SMTP id f21mr66514370ejx.265.1609782500215;
        Mon, 04 Jan 2021 09:48:20 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.238])
        by smtp.gmail.com with ESMTPSA id l14sm44107750edq.35.2021.01.04.09.48.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:19 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH v8 43/44] kernel-shark: Add VirtBridge and VirtGap classes
Date:   Mon,  4 Jan 2021 19:47:23 +0200
Message-Id: <20210104174724.70404-44-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210104174724.70404-1-y.karadz@gmail.com>
References: <20210104174724.70404-1-y.karadz@gmail.com>
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

