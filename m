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
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1FBBC433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:47:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7944623B52
	for <linux-trace-devel@archiver.kernel.org>; Wed,  9 Dec 2020 13:47:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732405AbgLINr1 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 08:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732415AbgLINr1 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 08:47:27 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F9DC06138C
        for <linux-trace-devel@vger.kernel.org>; Wed,  9 Dec 2020 05:46:13 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id t16so1815133wra.3
        for <linux-trace-devel@vger.kernel.org>; Wed, 09 Dec 2020 05:46:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vMtoru4ysgIyI4OZqBtUfzLnZQxv1b5TDuVhnuc4b6I=;
        b=hwFWwzDqMRooLivcT+4m7iDv2AJU2vzWVjH3Kff5j2O+TzSsRHowQUMmuIgpWPEOn7
         gDYciTI0Si2lxyJNzmkrGmF62Rlofop68PtwrgclDyzmfvvqYgWdeFsgPIgj3jBDeh6j
         /hsmxO32DLt1I/AWaeCl26LR1Jwue2G61OaRFuXVtbfgyUN7tZ6Vy6TpHbUKLno1HqLf
         V7hF3WSwvhl7xIqPfcaMT/U9noXykmjdnvRiU73xVjs7ULn4jT+qaRhU6K9CxHvehbw0
         xmyCcD5jPB7ku1UTHj3bzixoApx7uTvEygpNEtKfSRanLtKxhomRNyMzlzdYPLWvKuR/
         039w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vMtoru4ysgIyI4OZqBtUfzLnZQxv1b5TDuVhnuc4b6I=;
        b=LrC6WNk+YUyfzPCLOXe23DBHY9jU1kBAs/9lSA800V9SSbh7HkImDWj4Ov0x+eDaUc
         PVXYBnQyuhEF52tgGwlmpivvBtK34/7OKOA48T7qXt6oykvgjZrk9abRhtVg7m9wzf49
         m/QAKue9og6y1htxvH2+NqxretZcJpkp7IqoR+B9+VC2We7jY9IlW9KNORUBdrJCYMic
         hhiRjXoZ707/WTxbvBRsYjsuL1zHu/9iZfdK6I7lLI/tA5x3v+oEXN+SqxF5drmMf5qG
         nCHy4o78uYswXoYw7zfbon6ZmfV63he65jErECMiI3VcM3cXwKW6K9dldVov/7zFlS0P
         Nu3g==
X-Gm-Message-State: AOAM533ZvlRHjyEO0Jz7duCt5WuKl0g0Vd/QlyGNYtlCoOo1+95WpZYU
        Yw/r5hmIITeSWq2xjfkJy/6vZKknzMU=
X-Google-Smtp-Source: ABdhPJySiw/TQ6/25WKKX7Imq/GmOIEFXQiTQMq8YPqDOvRzKZhnoI8gTWgo/WtPcesg/GQx3UuAyA==
X-Received: by 2002:adf:a319:: with SMTP id c25mr2868589wrb.262.1607521572400;
        Wed, 09 Dec 2020 05:46:12 -0800 (PST)
Received: from localhost.localdomain ([95.87.199.104])
        by smtp.gmail.com with ESMTPSA id s1sm4029431wrv.97.2020.12.09.05.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 05:46:11 -0800 (PST)
From:   "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
To:     rostedt@goodmis.org
Cc:     linux-trace-devel@vger.kernel.org,
        "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Subject: [PATCH 07/10] kernel-shark: Remove the hard-coded Idle PID
Date:   Wed,  9 Dec 2020 15:45:27 +0200
Message-Id: <20201209134530.428368-8-y.karadz@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201209134530.428368-1-y.karadz@gmail.com>
References: <20201209134530.428368-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

KernelShark plots differently all events coming from Idle tasks.
This is done in order to provide more intuitive visualization of
the Idleness of the system. So far the process Id of the Idle task
was assumed to be Zero. However this is true only for Linux systems.
In this patch we make the PID of the Idle task configurable.

Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
---
 src/KsPlotTools.cpp | 48 +++++++++++++++++++++++++++++++++------------
 src/KsPlotTools.hpp | 22 +++++++++------------
 2 files changed, 44 insertions(+), 26 deletions(-)

diff --git a/src/KsPlotTools.cpp b/src/KsPlotTools.cpp
index d952f5e..529f737 100644
--- a/src/KsPlotTools.cpp
+++ b/src/KsPlotTools.cpp
@@ -755,12 +755,13 @@ Graph::Graph()
 : _histoPtr(nullptr),
   _bins(nullptr),
   _size(0),
-  _hMargin(30),
   _collectionPtr(nullptr),
   _binColors(nullptr),
   _ensembleColors(nullptr),
   _label(),
-  _zeroSuppress(false)
+  _idleSuppress(false),
+  _idlePid(0),
+  _drawBase(true)
 {}
 
 /**
@@ -774,12 +775,13 @@ Graph::Graph(kshark_trace_histo *histo, KsPlot::ColorTable *bct, KsPlot::ColorTa
 : _histoPtr(histo),
   _bins(new(std::nothrow) Bin[histo->n_bins]),
   _size(histo->n_bins),
-  _hMargin(30),
   _collectionPtr(nullptr),
   _binColors(bct),
   _ensembleColors(ect),
   _label(),
-  _zeroSuppress(false)
+  _idleSuppress(false),
+  _idlePid(0),
+  _drawBase(true)
 {
 	if (!_bins) {
 		_size = 0;
@@ -904,6 +906,20 @@ void Graph::setLabelAppearance(ksplot_font *f, Color col, int lSize, int hMargin
 	}
 }
 
+/**
+ * @brief Set Idle Suppression. If True, the bins containing Idle task records
+ *	  are not grouped together.
+ *
+ * @param is: If True, Idle is suppressed.
+ * @param ip: The process Id of the Idle task. If Idle is not suppressed, this
+ *	      value has no effect.
+ */
+void Graph::setIdleSuppressed(bool is, int ip)
+{
+	_idleSuppress = is;
+	_idlePid = ip;
+}
+
 /**
  * @brief Set the value of a given bin.
  *
@@ -916,7 +932,7 @@ void Graph::setBinValue(int bin, int val)
 }
 
 /**
- * @brief Set the Process Id (Front and Back) a given bin.
+ * @brief Set the Process Id (Front and Back) of a given bin.
  *
  * @param bin: Bin Id.
  * @param pidF: The Process Id detected at the from (first in time) edge of
@@ -1328,22 +1344,28 @@ void Graph::draw(float size)
 
 	_label.draw();
 
-	/*
-	 * Start by drawing a line between the base points of the first and
-	 * the last bin.
-	 */
-	drawLine(_bins[0]._base, _bins[_size - 1]._base, {}, size);
+	if (_drawBase) {
+		/*
+		 * Start by drawing a line between the base points of the first and
+		 * the last bin.
+		 */
+		drawLine(_bins[0]._base, _bins[_size - 1]._base, {}, size);
+	}
 
 	/* Draw as vartical lines all bins containing data. */
 	for (int i = 0; i < _size; ++i)
-		if (_bins[i]._idFront >= 0 || _bins[i]._idBack >= 0)
+		if (_bins[i]._idFront >= 0 || _bins[i]._idBack >= 0 ||
+		    _bins[i]._idFront == _idlePid || _bins[i]._idBack ==_idlePid)
 			if (_bins[i]._visMask & KS_EVENT_VIEW_FILTER_MASK) {
 				_bins[i]._size = size;
 				_bins[i].draw();
 			}
 
 	auto lamCheckEnsblVal = [this] (int v) {
-		return v > 0 || (v == 0 && !this->_zeroSuppress);
+		if (_idleSuppress && v == _idlePid)
+			return false;
+
+		return v >= 0;
 	};
 
 	/*
@@ -1424,4 +1446,4 @@ void Graph::draw(float size)
 	}
 }
 
-}; // KsPlot
+} // KsPlot
diff --git a/src/KsPlotTools.hpp b/src/KsPlotTools.hpp
index 8f530b0..5ce8f6f 100644
--- a/src/KsPlotTools.hpp
+++ b/src/KsPlotTools.hpp
@@ -449,7 +449,7 @@ public:
 	 */
 	Graph(const Graph &) = delete;
 
-	/* Disable moving. Same as copying.*/
+	/* Disable moving. Same as copying. */
 	Graph(Graph &&) = delete;
 
 	Graph(kshark_trace_histo *histo, KsPlot::ColorTable *bct,
@@ -512,18 +512,10 @@ public:
 	void setLabelAppearance(ksplot_font *f, Color col,
 				int lSize, int hMargin);
 
-	/**
-	 * Check if this graph is Zero Suppressed. Zero Suppressed means that
-	 * bins having Id value = 0 (Idle task records) are not grouped
-	 * together.
-	 */
-	bool zeroSuppressed(bool zs) {return _zeroSuppress;}
+	void setIdleSuppressed(bool is, int ip = 0);
 
-	/**
-	 * Set Zero Suppression. If True, the bins having Id value = 0 (Idle
-	 * task records) are not grouped together.
-	 */
-	void setZeroSuppressed(bool zs) {_zeroSuppress = zs;}
+	/** Draw the base line of the graph or not. */
+	void setDrawBase(bool b) {_drawBase = b;}
 
 protected:
 	/** Pointer to the model descriptor object. */
@@ -559,7 +551,11 @@ protected:
 private:
 	TextBox		_label;
 
-	bool			_zeroSuppress;
+	bool	_idleSuppress;
+
+	int	_idlePid;
+
+	bool	_drawBase;
 
 	void	_initBins();
 
-- 
2.25.1

