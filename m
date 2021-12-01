Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9601C433EF
	for <linux-trace-devel@archiver.kernel.org>; Wed,  1 Dec 2021 02:24:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241184AbhLAC2Q (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 21:28:16 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:57285 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233144AbhLAC2P (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 21:28:15 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 3ADC95C0184;
        Tue, 30 Nov 2021 21:24:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 30 Nov 2021 21:24:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm1; bh=HkJo0qvMWtECqB/2EPa9hJnTea
        9Ps0X0dlgjly3oggQ=; b=f/1sT0kXKH0gdd6lCnZ4FSV+Whs0fTOny7qVWblZel
        lfwHtWeKFuThngBUVc0F1GAu9qEXonENsdIMxvwFErb6TRcwkKJlEFfMKQ4YJIri
        fNBcVy1/gn6/6kP+PphCic08ImXVR9bl5Au26Xk3JzmpOpL5ugtu9zHQwW/uHm3Z
        CxdNcIIt0iwwItLwt4AO10q2hsUQ4MrGzqjBAkjWsacjPRWTdlmzorEamdKyk0It
        sPE02oo4XTBLgyM7C0PtnFOwxwVjnpvu7QwLXDAjR2U5blUMhnzGqcV3deXsQkGm
        8WhpmmMlO8u1fRUGZ6yBWju7ydqzs0jkKc36AtNOUaRg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=HkJo0qvMWtECqB/2E
        Pa9hJnTea9Ps0X0dlgjly3oggQ=; b=LsY4auBKS88ZtFLE955vj/IpdIskWnGCU
        P6RhxPoYHSGl2vTxeKiVGpWCGH4RHANsqjbWP0WoZ5kbMr/V8Ie3vX7WeB/kYY+4
        JL/gBw1dLClTf0OwoE/LNo7rxcgiUVF0LpadEFG8F3DrGHsvJVl0/hVuKP60BkAX
        gm69Hi3ceyUgzvF4nYKA97I1bos+Nb0nSjFKbhkngwd7+i0ggmg8GP+/1a1kw3SI
        tuMWJE//AtfBXp5l1Ls6zct4JDKVmRGTqcxTBUjxcfkUh+xxrcqmtaGizNjnKGhf
        S2O8fpLRkMvL9u/MX1GWh+/9jw0EE+Ue1mdib5wkEsFLRGlokKSgg==
X-ME-Sender: <xms:9tymYcCKD9rGxzuO4k-9nT07TBm6pZFw9A4c4WGqvBrHDT_oBVQpIQ>
    <xme:9tymYeivPIBT0EKpAq3yT4Pl6TizZGtZVrQOqY1cuqiw77m4aHtuYdP8PXMdn6Hhj
    SzUAAJYuClxpcrisg>
X-ME-Received: <xmr:9tymYfmtIXG0qbWy_tEkz4BtakPM8zEKzBokJJ6NJEpLNAqFFcTv3KmwQSwAWpw8Ka-j5JePMTM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddriedvgdegjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpefoihgthhgrvghlucfurghrthgrihhnuceomhhikhgvshgrrhhtsehf
    rghsthhmrghilhdrtghomheqnecuggftrfgrthhtvghrnhepjedtgefhledufedvgfelke
    etteetieeghfefudehvdefjeektedtvdefjeefgedvnecuvehluhhsthgvrhfuihiivgep
    tdenucfrrghrrghmpehmrghilhhfrhhomhepmhhikhgvshgrrhhtsehfrghsthhmrghilh
    drtghomh
X-ME-Proxy: <xmx:99ymYSw1FAK5xpFjfNOZmOdaEOQdupywU8lMSESWE8-k_indq8Bxiw>
    <xmx:99ymYRTwM3MX8p347TxgpOjpzv2fSBjpCaFEh-C6nvnZFzNmjYOP0g>
    <xmx:99ymYdbMJeJwhmkbZLE3Ok-3MqxCNlc4iu_wuMTXWYAueRQTzXBKEg>
    <xmx:99ymYS4xr3RLCj5_f41G-vqwRJUbjYPck85-xisHek0skOJwcmqglg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 30 Nov 2021 21:24:54 -0500 (EST)
From:   Michael Sartain <mikesart@fastmail.com>
To:     linux-trace-devel@vger.kernel.org
Cc:     Michael Sartain <mikesart@fastmail.com>
Subject: [PATCH] trace-cmd library: Add API to get information from trace file
Date:   Tue, 30 Nov 2021 19:24:31 -0700
Message-Id: <20211201022431.64763-1-mikesart@fastmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New APIs added to get trace cpustats, uname, version strings, and
cpu file sizes and offsets.

  const char *tracecmd_get_cpustats(struct tracecmd_input *handle);
  const char *tracecmd_get_uname(struct tracecmd_input *handle);
  const char *tracecmd_get_version(struct tracecmd_input *handle);
  unsigned long long tracecmd_get_cpu_file_offset(struct tracecmd_input *handle, int cpu);
  unsigned long long tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu);

Signed-off-by: Michael Sartain <mikesart@fastmail.com>
---
 .../include/private/trace-cmd-private.h       |  6 +++++
 lib/trace-cmd/trace-input.c                   | 25 +++++++++++++++++++
 2 files changed, 31 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c58b09e..cd78cc9 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -90,6 +90,12 @@ bool tracecmd_get_quiet(struct tracecmd_output *handle);
 void tracecmd_set_out_clock(struct tracecmd_output *handle, const char *clock);
 const char *tracecmd_get_trace_clock(struct tracecmd_input *handle);
 
+const char *tracecmd_get_cpustats(struct tracecmd_input *handle);
+const char *tracecmd_get_uname(struct tracecmd_input *handle);
+const char *tracecmd_get_version(struct tracecmd_input *handle);
+unsigned long long tracecmd_get_cpu_file_offset(struct tracecmd_input *handle, int cpu);
+unsigned long long tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu);
+
 static inline int tracecmd_host_bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ac57bc4..99dbca2 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4088,6 +4088,31 @@ const char *tracecmd_get_trace_clock(struct tracecmd_input *handle)
 	return handle->trace_clock;
 }
 
+const char *tracecmd_get_cpustats(struct tracecmd_input *handle)
+{
+	return handle->cpustats;
+}
+
+const char *tracecmd_get_uname(struct tracecmd_input *handle)
+{
+	return handle->uname;
+}
+
+const char *tracecmd_get_version(struct tracecmd_input *handle)
+{
+	return handle->version;
+}
+
+unsigned long long tracecmd_get_cpu_file_offset(struct tracecmd_input *handle, int cpu)
+{
+	return (cpu < handle->cpus) ? handle->cpu_data[cpu].file_offset : 0;
+}
+
+unsigned long long tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu)
+{
+	return (cpu < handle->cpus) ? handle->cpu_data[cpu].file_size : 0;
+}
+
 /**
  * tracecmd_get_show_data_func - return the show data func
  * @handle: input handle for the trace.dat file
-- 
2.33.0

