Return-Path: <SRS0=opg7=KS=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:55912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727616AbeHCUqU (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 Aug 2018 16:46:20 -0400
Date: Fri, 3 Aug 2018 14:48:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org,
        Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH v2 3/7] kernel-shark-qt: Introduce the visualization
 model used by the Qt-based KS
Message-ID: <20180803144848.457f5f45@gandalf.local.home>
In-Reply-To: <20180731205113.2fe79e72@gandalf.local.home>
References: <20180731135248.30587-1-y.karadz@gmail.com>
        <20180731135248.30587-4-y.karadz@gmail.com>
        <20180731205113.2fe79e72@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 31 Jul 2018 20:51:13 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> > +static void ksmodel_reset_bins(struct kshark_trace_histo *histo,
> > +			       size_t first, size_t last)
> > +{
> > +	/* Reset the content of the bins. */
> > +	memset(&histo->map[first], KS_EMPTY_BIN,
> > +	       (last - first + 1) * sizeof(histo->map[0]));  
> 
> This patch should add a comment here and by KS_EMPTY_BIN stating that
> KS_EMPTY_BIN is expected to be -1, as it is used to reset the entire
> array with memset(). As memset() only updates an array to a single
> byte, that byte must be the same throughout. Which works for zero and
> -1.
> 

Note, I added this too.

-- Steve

diff --git a/kernel-shark-qt/src/libkshark.h b/kernel-shark-qt/src/libkshark.h
index 4860e74d..122c030e 100644
--- a/kernel-shark-qt/src/libkshark.h
+++ b/kernel-shark-qt/src/libkshark.h
@@ -225,7 +225,10 @@ bool kshark_match_pid(struct kshark_context *kshark_ctx,
 bool kshark_match_cpu(struct kshark_context *kshark_ctx,
 		      struct kshark_entry *e, int cpu);
 
-/** Empty bin identifier. */
+/** Empty bin identifier.
+ * KS_EMPTY_BIN is used to reset entire arrays to empty with memset(),
+ * thus it must be -1 for that to work.
+ */
 #define KS_EMPTY_BIN		-1
 
 /** Filtered bin identifier. */
