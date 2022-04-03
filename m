Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5406FC433EF
	for <linux-trace-devel@archiver.kernel.org>; Sun,  3 Apr 2022 15:24:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352641AbiDCP02 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sun, 3 Apr 2022 11:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232531AbiDCP02 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sun, 3 Apr 2022 11:26:28 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1D1366BC
        for <linux-trace-devel@vger.kernel.org>; Sun,  3 Apr 2022 08:24:34 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id kd21so5704129qvb.6
        for <linux-trace-devel@vger.kernel.org>; Sun, 03 Apr 2022 08:24:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=8yH/qooq1tzoBQtMcgZWH/IlHRhjf2oiHymxvgRH/34=;
        b=B9VslNDKy9t8TVIrgReIpNm6xnDsZwGdnD1+Bxe10SCorLDMRz+tS+OVJ632YgB9i0
         BzquGJvnnqobwsIdYMVIIxPXTlI6LJ+GcxknjtlGo9pdk77R7fOVaz5XWpRZOQvAwqfm
         Wr+1FHr5UnrhpTdKgmR0tVqHlp6AmMuod+QCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=8yH/qooq1tzoBQtMcgZWH/IlHRhjf2oiHymxvgRH/34=;
        b=smPtLztHW73k7bfskG1l3GI2SQHrVzopuTxSZu/hThh1cCl4npefJsgJrL9poc17ML
         NCzzzbUzLqCXTtaMq47vrEtdYXMI0sr0Bl7Mt+zH5hghXcY6uAuuYXjvdsI1rP+BtvPQ
         h2ydLZHL1gbBRnXGr8E/1+FU2WmyzwijzQzSn61v2sAtqbnxZDl0mhygaL9L1H6dLQC2
         u7sfdHHD+lJ8F6Nphp5hDmY8nHkmkeXH8LECb/wbDu/qPUgXMCEEkoHSTfWvP/Dj5dTM
         DJ5pVUTZfjY+IZ6xd+cmkJOA41XcE6u/bQjslYUX1ykGqRP1xjmHptXDLDelLiGOhsrf
         B+cA==
X-Gm-Message-State: AOAM530a7KQ3bM34YwAiYp6gIdN9wTuZ6PH34RmcirpPyrTVlNSf1Pzb
        q52Y9C6UOOdJtEhMlWAGmvwIKg==
X-Google-Smtp-Source: ABdhPJyD3INMIwllDHJQh449eDTCmQV5USvrGOJo3WWnpB0RPeB5tugRcwFoGJIG/xTb+JLvBdfxbA==
X-Received: by 2002:a0c:d845:0:b0:42c:33e4:e491 with SMTP id i5-20020a0cd845000000b0042c33e4e491mr14129487qvj.100.1648999473851;
        Sun, 03 Apr 2022 08:24:33 -0700 (PDT)
Received: from localhost (29.46.245.35.bc.googleusercontent.com. [35.245.46.29])
        by smtp.gmail.com with ESMTPSA id z6-20020ae9c106000000b0067d3b9ef387sm4757427qki.28.2022.04.03.08.24.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Apr 2022 08:24:33 -0700 (PDT)
Date:   Sun, 3 Apr 2022 15:24:33 +0000
From:   Joel Fernandes <joel@joelfernandes.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-trace-devel@vger.kernel.org, rostedt@google.com,
        vineethrp@google.com, Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Subject: Re: [PATCH] trace-cmd: Try alternate path for message cache
Message-ID: <Ykm8MfLnjrcRf/64@google.com>
References: <20220329191801.429691-1-joel@joelfernandes.org>
 <20220401153737.7c444426@gandalf.local.home>
 <CAEXW_YQxPgaKOMhDy8kVdaT9esvY8ctP1Mfw3RZXwkJkTYhh0w@mail.gmail.com>
 <20220401190629.32564bd2@gandalf.local.home>
 <Ykm1jBpdD0+NjsTW@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Ykm1jBpdD0+NjsTW@google.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun, Apr 03, 2022 at 02:56:12PM +0000, Joel Fernandes wrote:
> On Fri, Apr 01, 2022 at 07:06:29PM -0400, Steven Rostedt wrote:
> > On Fri, 1 Apr 2022 15:50:10 -0400
> > Joel Fernandes <joel@joelfernandes.org> wrote:
> > 
> > > export TRACECMD_TEMPDIR="/data"
> > > 
> > > That’s fair. What about using memfd for this, do you feel that’s
> > > reasonable? I have not yet measured how big this file gets but if it’s
> > > small enough that might work too.
> > 
> > Is this a separate question? That is, do you mean using the above
> > environment variable *and* then use memfd?
> > 
> > I believe that the cache is used for passing the compressed data from the
> > guest to the host. I don't think it will be more than one compressed chunk.
> > 
> > But Tzvetomir would know better.
> 
> Hey Steve,
> No its the same question. Instead of temp file, I was proposing in-memory
> file using memfd_create(2), that way no hassle as long as the file is not too
> huge.
> 
> Also looks like my patch is incomplete anyway, I need to change
> tracecmd_msg_handle_cache() as well.
> 
> I'll try to write up a patch with memfd unless you guys disagree.

Something like the following seems to work, and the file grows to only 4KB.
Note with memfd, the file name does not have to be unique and the fd entry
in the process denotes the file's uniqueness.

I'll roll it into a patch, let me know if you disagree:

---8<---

diff --git a/lib/trace-cmd/include/private/trace-cmd-private.h b/lib/trace-cmd/include/private/trace-cmd-private.h
index 6934376..3aee139 100644
--- a/lib/trace-cmd/include/private/trace-cmd-private.h
+++ b/lib/trace-cmd/include/private/trace-cmd-private.h
@@ -377,7 +377,6 @@ enum tracecmd_msg_flags {
 };
 
 /* for both client and server */
-#define MSG_CACHE_FILE "/tmp/trace_msg_cacheXXXXXX"
 struct tracecmd_msg_handle {
 	int			fd;
 	short			cpu_count;
@@ -386,7 +385,6 @@ struct tracecmd_msg_handle {
 	bool			done;
 	bool			cache;
 	int			cfd;
-	char			cfile[sizeof(MSG_CACHE_FILE)];
 };
 
 struct tracecmd_tsync_protos {
diff --git a/lib/trace-cmd/trace-msg.c b/lib/trace-cmd/trace-msg.c
index 03b853e..1472f20 100644
--- a/lib/trace-cmd/trace-msg.c
+++ b/lib/trace-cmd/trace-msg.c
@@ -593,11 +593,9 @@ tracecmd_msg_handle_alloc(int fd, unsigned long flags)
 int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle)
 {
 	if (msg_handle->cfd < 0) {
-		strcpy(msg_handle->cfile, MSG_CACHE_FILE);
-		msg_handle->cfd = mkstemp(msg_handle->cfile);
+		msg_handle->cfd = memfd_create("trace_msg_cache", 0);
 		if (msg_handle->cfd < 0)
 			return -1;
-		unlink(msg_handle->cfile);
 	}
 	msg_handle->cache = true;
 	return 0;
