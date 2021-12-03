Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 678C9C433F5
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 Dec 2021 23:30:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240729AbhLCXdh (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 Dec 2021 18:33:37 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:46905 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240573AbhLCXdg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Dec 2021 18:33:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 9DC8B3200F72;
        Fri,  3 Dec 2021 18:30:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 03 Dec 2021 18:30:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fastmail.com; h=
        date:from:to:cc:subject:message-id:mime-version:content-type; s=
        fm1; bh=u+7aD8QARtNVycnZp/K9bebf8cC7fyORkS+w1I2AqDw=; b=DGIgLkGi
        t0uvtIjLRZ/HsRbWnAf9EkGd08yWNeXy4B8ha3cSOszzqtEqU/HYp2tT49dTNK7h
        yrsczWuoZfJTuvrLyaCWz5DkbNjcGu2nvp2lVFjE14HJiV+16hE+UlqJbKgBtOfi
        B4r1410SP8/ll/hrCmOOaaFF5uConX982aKr4DnsiGkBFh0nqfxnLnAlQ2wjAKaW
        5a7MVLaGobk9cWvmPYk1MVl6/3p2NDRlsYL7leCuFr19zglj4GHq4dJN8vzTj6UT
        maSV7OjeUAugOJB4CL7+eSw8ZoFL4zeUVq4/U4Yv5UIgH+pTJjx/J+1A5wLM3B1H
        wYx4RrFQqJ/L6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:message-id
        :mime-version:subject:to:x-me-proxy:x-me-proxy:x-me-sender
        :x-me-sender:x-sasl-enc; s=fm1; bh=u+7aD8QARtNVycnZp/K9bebf8cC7f
        yORkS+w1I2AqDw=; b=KQzcHBciyo540v0rlE6jV742Tihm+vnTT0T1NRf7etYHA
        pqdyT8a9DDQkD3rx6FeNMTYE+6gHISKF8sV1DQ3Bcq5yYhJe7SNBvxJnsSviE+oG
        vv7XHPErpuKH24klpB1EeB7bwx6BmDnZM+XYQM2OC0cipS67Uo9RNwoTE/PU5b6A
        UcrDFJHhohH/e+kWDvSU69V6s9UZuHObcYn5eMrtst0XRUuPNm1lhxcjT9RxLBlq
        rZhpNwL3FGZhpfPFxeG/4kps1EbMLKnHziR3ddM6sD/RibuIrNUm3yvoNOspCoPW
        LhkMW9B5kpPpD9HiyZhuHjrkS6RJIE3208/rTmXwQ==
X-ME-Sender: <xms:gqiqYQ-5r3vCKH4kWXNrYqxIAu_Q6TFbWSMt8EtIAbHpjmIcDxYp0w>
    <xme:gqiqYYth322hVg5MHw2s0DO7oTsog_10u7haM8NHHt9P3GHTuAcwIhiT2CZz9o1zV
    ep3F3CkQTtdXI4jvw>
X-ME-Received: <xmr:gqiqYWDCQ-dLKfVT1eu3tW7-BILb8bDkF8sabm1Eae-Z7FuXXM9_nbxvxD8wEv4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrieekgddtkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkgggtugesthdtredttddtvdenucfhrhhomhepofhitghhrggvlhcu
    ufgrrhhtrghinhcuoehmihhkvghsrghrthesfhgrshhtmhgrihhlrdgtohhmqeenucggtf
    frrghtthgvrhhnpefftdelueeffeevkefhvdeigeffiefhkeeuieffleevjeevhfeiteek
    vedtffejtdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhroh
    hmpehmihhkvghsrghrthesfhgrshhtmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:gqiqYQdv3w0tRKr__aiTBBM0LYJfFMuGdhgEIym233M2wpgSKMaVOg>
    <xmx:gqiqYVNUmk59XEfADg7kGTg7WtQ-tW699nv4WD15_07WN7hUauLaoQ>
    <xmx:gqiqYakV41aEOwNvbSYAdyw07WIEz6lOqW6gUOjEbDPzIi9xBjOM2Q>
    <xmx:g6iqYT20HBB9y4Px6AfyMqxswpp2D_FBuE3zWJ5Eo-56HTxw_ZxXqQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Dec 2021 18:30:10 -0500 (EST)
Date:   Fri, 3 Dec 2021 16:30:08 -0700
From:   Michael Sartain <mikesart@fastmail.com>
To:     linux-trace-devel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Cc:     Michael Sartain <mikesart@fastmail.com>
Subject: [PATCH v2] trace-cmd library: Add API to get information from trace
 file
Message-ID: <20211203233008.6mq5lsuypsu24dsw@mikesart-tr3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

New APIs added to get trace cpustats, uname, version strings, and
cpu file sizes.

  const char *tracecmd_get_cpustats(struct tracecmd_input *handle);
  const char *tracecmd_get_uname(struct tracecmd_input *handle);
  const char *tracecmd_get_version(struct tracecmd_input *handle);
  unsigned long long tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu);

Signed-off-by: Michael Sartain <mikesart@fastmail.com>
---
 .../include/private/trace-cmd-private.h       |  5 ++
 lib/trace-cmd/trace-input.c                   | 63 +++++++++++++++++++
 2 files changed, 68 insertions(+)

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index c58b09e..6e2af31 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -90,6 +90,11 @@ bool tracecmd_get_quiet(struct tracecmd_output *handle);
 void tracecmd_set_out_clock(struct tracecmd_output *handle, const char *clock);
 const char *tracecmd_get_trace_clock(struct tracecmd_input *handle);
 
+const char *tracecmd_get_cpustats(struct tracecmd_input *handle);
+const char *tracecmd_get_uname(struct tracecmd_input *handle);
+const char *tracecmd_get_version(struct tracecmd_input *handle);
+off64_t tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu);
+
 static inline int tracecmd_host_bigendian(void)
 {
 	unsigned char str[] = { 0x1, 0x2, 0x3, 0x4 };
diff --git a/lib/trace-cmd/trace-input.c b/lib/trace-cmd/trace-input.c
index ac57bc4..c55adcd 100644
--- a/lib/trace-cmd/trace-input.c
+++ b/lib/trace-cmd/trace-input.c
@@ -4088,6 +4088,69 @@ const char *tracecmd_get_trace_clock(struct tracecmd_input *handle)
 	return handle->trace_clock;
 }
 
+/**
+ * tracecmd_get_cpustats - return the saved cpu stats
+ * @handle: input handle for the trace.dat file
+ *
+ * Provides a method to extract the cpu stats saved in @handle.
+ *
+ * Returns a string of the cpu stats that was saved in the trace.dat file.
+ * The string should not be freed, as it points to the internal
+ * structure data.
+ */
+const char *tracecmd_get_cpustats(struct tracecmd_input *handle)
+{
+	return handle->cpustats;
+}
+
+/**
+ * tracecmd_get_uname - return the saved name and kernel information
+ * @handle: input handle for the trace.dat file
+ *
+ * Provides a method to extract the system information saved in @handle.
+ *
+ * Returns a string of the system information that was saved in the
+ * trace.dat file.
+ * The string should not be freed, as it points to the internal
+ * structure data.
+ */
+const char *tracecmd_get_uname(struct tracecmd_input *handle)
+{
+	return handle->uname;
+}
+
+/**
+ * tracecmd_get_version - return the saved version information
+ * @handle: input handle for the trace.dat file
+ *
+ * Provides a method to extract the version string saved in @handle.
+ *
+ * Returns a string of the version that was saved in the trace.dat file.
+ * The string should not be freed, as it points to the internal
+ * structure data.
+ */
+const char *tracecmd_get_version(struct tracecmd_input *handle)
+{
+	return handle->version;
+}
+
+/**
+ * tracecmd_get_cpu_file_size - return the saved cpu file size
+ * @handle: input handle for the trace.dat file
+ * @cpu: cpu index
+ *
+ * Provides a method to extract the cpu file size saved in @handle.
+ *
+ * Returns the cpu file size saved in trace.dat file or (off64_t)-1 for
+ * invalid cpu index.
+ */
+off64_t tracecmd_get_cpu_file_size(struct tracecmd_input *handle, int cpu)
+{
+	if (cpu < 0 || cpu >= handle->cpus)
+		return (off64_t)-1;
+	return handle->cpu_data[cpu].file_size;
+}
+
 /**
  * tracecmd_get_show_data_func - return the show data func
  * @handle: input handle for the trace.dat file
-- 
2.33.0

