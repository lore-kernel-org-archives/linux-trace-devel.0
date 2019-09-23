Return-Path: <SRS0=Mdk7=XS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6AE0C04EBF
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 14:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B23420867
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 14:28:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdwgJmi/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439871AbfIWO2o (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 10:28:44 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:35540 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2439850AbfIWO2o (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 10:28:44 -0400
Received: by mail-qt1-f195.google.com with SMTP id m15so17392276qtq.2;
        Mon, 23 Sep 2019 07:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6A8RKDCmDyC878dQzWO1YL9aQQceEgwXiR2QrHFFGlA=;
        b=hdwgJmi/OVMqfuXrRAZeb0OgAK6fayty3d7SxMspb13PzIAJPc2nxxdt/gg+2pFmMD
         ynAsDJOC+JhPaS+yH3wx0OWaSng4qioq1sLTr9M4c4pMcM/n4E2NcOedo/I62qscVYpI
         V9i7AZ/dmhgNg+B+CBUoxHSV2A9kcXRBfJXe4vr/tU62VADfBwiyM9qOCxSg44HHJPIQ
         oQRsLYSCN8+DPGjI3vJcio7U1zKVtRr2OhYKx+S1D0j26dEA/j8uncfEqeLpBfpQyRNn
         rDWDq3dZxdnBzMv8YLKaX92hiMgR7P0r7jVk270RCt6dqz3aqLqThOJwjAzPIpNo3pcE
         7m3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6A8RKDCmDyC878dQzWO1YL9aQQceEgwXiR2QrHFFGlA=;
        b=hlUqzZrk+44cjY4qZX9vbwNyhQV+eon8YbjF53R03DoOnIPayIbzl7awn17tf6PBPp
         deeKRsEYjjwDsPRHXqG3S+8w4DLWuAbv3wGKkCq6mSNDwaQ2nQUcPF+JhjvOJqBq5MHO
         gcM2N4Nq1c+/8JJEnKpj3QacS+ampvkLZ8oWoy33z+cv6m8vnl93fd1lLcFqX82DysZq
         7xto5VQ4nUXiVh2AyD/2IhSXl8gJ87TtRk0ECz8U9A1RARX/PGI6J/HXWO8gwm6OZ56m
         8Sfixx1b8cg73AjyHmRf4kq7dYRLH8bnGhI4eQ/pDZ0TzK/YKD2dsQ+uEdvyAEbjpJT0
         BZ0g==
X-Gm-Message-State: APjAAAW0ajnc58w87/LF84ki45kDvB1UvBz080mOEVKP1E/YMbLUNO2E
        QDxZIljR0zl6Ojnx5SPAXhY/vc7u
X-Google-Smtp-Source: APXvYqzu+1OF6w8eowpANLEXk423/6OlJh65DRR8MqDt7DSkgSyaTtx5szHDosXF8d6z2uOr5tAIKA==
X-Received: by 2002:ac8:1289:: with SMTP id y9mr164797qti.201.1569248922064;
        Mon, 23 Sep 2019 07:28:42 -0700 (PDT)
Received: from quaco.ghostprotocols.net ([179.97.35.50])
        by smtp.gmail.com with ESMTPSA id 44sm6646756qtt.13.2019.09.23.07.28.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 07:28:41 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 4EE6941105; Mon, 23 Sep 2019 11:28:39 -0300 (-03)
Date:   Mon, 23 Sep 2019 11:28:39 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] tools/lib/traceevent: Man page updates and some file
 movement
Message-ID: <20190923142839.GD16544@kernel.org>
References: <20190919212335.400961206@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919212335.400961206@goodmis.org>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Sep 19, 2019 at 05:23:35PM -0400, Steven Rostedt escreveu:
> Hi Arnaldo,
> 
> This is a series of man page updates to the libtraceevent code, as
> well as a fix to one missing prototype and some movement of the location
> of the plugins (to have the plugins in their own directory).

Thanks, applied.

- Arnaldo
 
> -- Steve
> 
> 
> 
> 
> Tzvetomir Stoyanov (2):
>       tools/lib/traceevent: Man pages for libtraceevent event print related API
>       tools/lib/traceevent: Man pages for tep plugins APIs
> 
> Tzvetomir Stoyanov (VMware) (4):
>       tools/lib/traceevent: Man pages fix, rename tep_ref_get() to tep_get_ref()
>       tools/lib/traceevent: Man pages fix, changes in event printing APIs
>       tools/lib/traceevent: Add tep_get_event() in event-parse.h
>       tools/lib/traceevent: Move traceevent plugins in its own subdirectory
> 
> ----
>  tools/lib/traceevent/Build                         |  11 -
>  .../Documentation/libtraceevent-event_print.txt    | 130 ++++++++++++
>  .../Documentation/libtraceevent-handle.txt         |   8 +-
>  .../Documentation/libtraceevent-plugins.txt        |  99 +++++++++
>  .../lib/traceevent/Documentation/libtraceevent.txt |  15 +-
>  tools/lib/traceevent/Makefile                      |  94 ++-------
>  tools/lib/traceevent/event-parse.h                 |   2 +
>  tools/lib/traceevent/plugins/Build                 |  10 +
>  tools/lib/traceevent/plugins/Makefile              | 222 +++++++++++++++++++++
>  .../lib/traceevent/{ => plugins}/plugin_cfg80211.c |   0
>  .../lib/traceevent/{ => plugins}/plugin_function.c |   0
>  .../lib/traceevent/{ => plugins}/plugin_hrtimer.c  |   0
>  tools/lib/traceevent/{ => plugins}/plugin_jbd2.c   |   0
>  tools/lib/traceevent/{ => plugins}/plugin_kmem.c   |   0
>  tools/lib/traceevent/{ => plugins}/plugin_kvm.c    |   0
>  .../lib/traceevent/{ => plugins}/plugin_mac80211.c |   0
>  .../traceevent/{ => plugins}/plugin_sched_switch.c |   0
>  tools/lib/traceevent/{ => plugins}/plugin_scsi.c   |   0
>  tools/lib/traceevent/{ => plugins}/plugin_xen.c    |   0
>  19 files changed, 485 insertions(+), 106 deletions(-)
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-event_print.txt
>  create mode 100644 tools/lib/traceevent/Documentation/libtraceevent-plugins.txt
>  create mode 100644 tools/lib/traceevent/plugins/Build
>  create mode 100644 tools/lib/traceevent/plugins/Makefile
>  rename tools/lib/traceevent/{ => plugins}/plugin_cfg80211.c (100%)
>  rename tools/lib/traceevent/{ => plugins}/plugin_function.c (100%)
>  rename tools/lib/traceevent/{ => plugins}/plugin_hrtimer.c (100%)
>  rename tools/lib/traceevent/{ => plugins}/plugin_jbd2.c (100%)
>  rename tools/lib/traceevent/{ => plugins}/plugin_kmem.c (100%)
>  rename tools/lib/traceevent/{ => plugins}/plugin_kvm.c (100%)
>  rename tools/lib/traceevent/{ => plugins}/plugin_mac80211.c (100%)
>  rename tools/lib/traceevent/{ => plugins}/plugin_sched_switch.c (100%)
>  rename tools/lib/traceevent/{ => plugins}/plugin_scsi.c (100%)
>  rename tools/lib/traceevent/{ => plugins}/plugin_xen.c (100%)

-- 

- Arnaldo
