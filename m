Return-Path: <SRS0=Mdk7=XS=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20FFEC4CEC4
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 17:38:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E918C2089F
	for <linux-trace-devel@archiver.kernel.org>; Mon, 23 Sep 2019 17:38:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GHgb8Gj9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394162AbfIWRib (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 23 Sep 2019 13:38:31 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:41421 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394159AbfIWRib (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 23 Sep 2019 13:38:31 -0400
Received: by mail-qk1-f193.google.com with SMTP id p10so16279458qkg.8;
        Mon, 23 Sep 2019 10:38:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=jVhjzvHtl5HnGqhTLYxKVj47U4X/BFJJeBsnSkYYla0=;
        b=GHgb8Gj9Eg7yyV8axYLveLmLIPVXs4qBekQCAj112ufQn96vUb9z3JrRVAxssUBxnE
         xp8W6LFwYHZ/nIObtw7HYngFclWG+eYErJ+gPA1CjHQekNEVMVOpZCTqCiV2xXyNmuJF
         SGT8BZ12WgC0fAt2oz7naCorGhKJdX46SUubM95ur0YInd7E3CyC8UtYJwZwdIb9xEUp
         FlordW2U2JYwO8TJNxd0o1yTrRlmjn4aHOVJ26AL1YF/STU/kSaSSG2DtV/STYCiXmT0
         FljyuE1XbGEmT5Qe11HkMOapPhlIfSWCg4fTm2azFON2D3m1kNHYT04WBU9lCWty1VV7
         4mZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=jVhjzvHtl5HnGqhTLYxKVj47U4X/BFJJeBsnSkYYla0=;
        b=adaR4q0RmGiA5bGMVCkCu96ppVD93ypnSGU0zxBwrBev1Shaqf3l0q7Ajdj7ICrNmw
         IurtMsYd42IBbwIciTm9s/4ZAjH5SyybqIuZPQ1ybAr+NY+gj6E4rMa62m/ZLoEElap+
         U4fOw3jEbxEn2exDvLDhN3ix4wlPMiNA9AJGy2xjHHA4i8PgflDIPYkIAAwAU9onvhuB
         9Dv3R4S2X73y3h9xx+Xzv3qohpAVCnwGOsjTv0PISRdtmrUN7aBdRMKkmIlpPOyJW9eo
         yP6rz6x3ckl2COtS0bw1mUmdSHzISCObVFE4WZBuRODgonXD+5GfXB1xtabV46JLZlbT
         Wfog==
X-Gm-Message-State: APjAAAWRD2D8+hONv3PdJN+a/uciE5CDDBj5g/05r7/ko8uIwL/GjOSS
        vq/ajPA4qRIPpug/XiF1LkU=
X-Google-Smtp-Source: APXvYqw9KCunNUQ8rqfLMPulMwZ5wIertQSZS+QZLf1Uj5+GYoyxOk0Yg+rWS8WR2DJusq1QAp2ylQ==
X-Received: by 2002:a05:620a:149a:: with SMTP id w26mr1090671qkj.234.1569260309090;
        Mon, 23 Sep 2019 10:38:29 -0700 (PDT)
Received: from quaco.ghostprotocols.net (189-94-129-1.3g.claro.net.br. [189.94.129.1])
        by smtp.gmail.com with ESMTPSA id v5sm7592368qtk.66.2019.09.23.10.38.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Sep 2019 10:38:28 -0700 (PDT)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 80F7241105; Mon, 23 Sep 2019 14:38:24 -0300 (-03)
Date:   Mon, 23 Sep 2019 14:38:24 -0300
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        linux-kernel@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/6] tools/lib/traceevent: Man page updates and some file
 movement
Message-ID: <20190923173824.GB28265@kernel.org>
References: <20190919212335.400961206@goodmis.org>
 <20190923142839.GD16544@kernel.org>
 <20190923143927.GE16544@kernel.org>
 <20190923145249.GF16544@kernel.org>
 <20190923111248.5ebdbfd5@oasis.local.home>
 <20190923115929.453b68f1@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190923115929.453b68f1@oasis.local.home>
X-Url:  http://acmel.wordpress.com
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Mon, Sep 23, 2019 at 11:59:29AM -0400, Steven Rostedt escreveu:
> On Mon, 23 Sep 2019 11:12:48 -0400
> Steven Rostedt <rostedt@goodmis.org> wrote:
> 
> > Yeah. Let's not apply this one yet till we figure out what broke. I'll
> > take a look at it too.
> 
> Does this help?

yeap, did the trick, I'm folding this one with the faulty one, thanks
for the prompt reply.

- Arnaldo
 
> -- Steve
> 
> diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
> index f9807d8c005b..7544166dd466 100644
> --- a/tools/perf/Makefile.perf
> +++ b/tools/perf/Makefile.perf
> @@ -292,7 +292,7 @@ endif
>  LIBTRACEEVENT = $(TE_PATH)libtraceevent.a
>  export LIBTRACEEVENT
>  
> -LIBTRACEEVENT_DYNAMIC_LIST = $(TE_PATH)libtraceevent-dynamic-list
> +LIBTRACEEVENT_DYNAMIC_LIST = $(TE_PATH)plugins/libtraceevent-dynamic-list
>  
>  #
>  # The static build has no dynsym table, so this does not work for
> @@ -737,7 +737,7 @@ libtraceevent_plugins: FORCE
>  	$(Q)$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) plugins
>  
>  $(LIBTRACEEVENT_DYNAMIC_LIST): libtraceevent_plugins
> -	$(Q)$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) $(OUTPUT)libtraceevent-dynamic-list
> +	$(Q)$(MAKE) -C $(TRACE_EVENT_DIR) $(LIBTRACEEVENT_FLAGS) O=$(OUTPUT) $(OUTPUT)plugins/libtraceevent-dynamic-list
>  
>  $(LIBTRACEEVENT)-clean:
>  	$(call QUIET_CLEAN, libtraceevent)

-- 

- Arnaldo
