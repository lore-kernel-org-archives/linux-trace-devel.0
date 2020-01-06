Return-Path: <SRS0=UiB3=23=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87C6CC33C8C
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 22:19:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5A12B2081E
	for <linux-trace-devel@archiver.kernel.org>; Mon,  6 Jan 2020 22:19:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hdCTFdcS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgAFWT7 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 6 Jan 2020 17:19:59 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45943 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbgAFWT7 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 6 Jan 2020 17:19:59 -0500
Received: by mail-qt1-f193.google.com with SMTP id l12so43719172qtq.12;
        Mon, 06 Jan 2020 14:19:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ra9GVssxYnn9Jv0jKh592D0gJEylVk6b1qXaRL8Qcy8=;
        b=hdCTFdcSDzDKK6xkyVsnM7SX8IJIEC0ncaSMPpmCfjpHoJ3ne0KeeWAXB3nAMUsrvL
         FcV5IisYscLVpLEv/CrHF2wiwmzEHiPxluYAbILZFlfpyM1qlpvwexQmti/kuN955k/h
         L0j4gdXA1iIDPJw65Nqc+Yf5XT2JStkRKzQdNib4XvUTLJMGe8rkDQ66W8PQWTX//nkO
         IQFbDSI0f45UjuIpeVI49ZMYpKZkMDHxhdpWevi6gWSGoiw87QTyzmLJGBPrT/lM8CIM
         37T3rpnqnD2HDtYyRh2nQ0OSqEHNZoNltH1ZpZWOS4dIPXAGAs2gjsAYgIk/Ckd3Asc7
         f4Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ra9GVssxYnn9Jv0jKh592D0gJEylVk6b1qXaRL8Qcy8=;
        b=Hn8emVBDujx1Df2PW5Va2kCmhNlyq3rkyKYeB+AIsxDAFk+JH4PsoVNJwTmSJRJf3m
         SwBGC/Blf0PG8bksNvqBK3B3W9s0KxreljjMuXE362GCVXxRQE/6dGEaJpB0k+tYCVTh
         8ivmPdTVtvVdkTuxIBj1sktMjZXCkpsGI5g8NkiaLFHSX3y3XEjiwqdei8Y395Gm5BYf
         BXpfNr4Mlz6lcn48OJhx/nI8u4k/Dl12SGGSaAYAPbneYR5C9tukdO0vNQ1vzpUK5i5s
         /c/ndyNz62V9LLiyJLQmsf9UCVR5FBszVVZl/4lrC6TjUFj3nB0C49cnAdfeAvnCsdaq
         A+PQ==
X-Gm-Message-State: APjAAAUi4AltW5DTHv5p4bfMb3PLUsjJLzd2RscqSUKMqRCJ496KGDLs
        MrcZt8efg9KDbLfqXH49D2Y599tpg5M=
X-Google-Smtp-Source: APXvYqwJCr/tvHE+vpfWKO5QRrw7Twha5XmvoqKiKgkMGGBQYkr8kBHkLcYGU+sBbJD24A6zL+JD/A==
X-Received: by 2002:ac8:5215:: with SMTP id r21mr76183728qtn.77.1578349197920;
        Mon, 06 Jan 2020 14:19:57 -0800 (PST)
Received: from quaco.ghostprotocols.net ([179.97.37.151])
        by smtp.gmail.com with ESMTPSA id n190sm21616014qke.90.2020.01.06.14.19.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jan 2020 14:19:57 -0800 (PST)
From:   Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>
X-Google-Original-From: Arnaldo Carvalho de Melo <acme@kernel.org>
Received: by quaco.ghostprotocols.net (Postfix, from userid 1000)
        id 856B440DFD; Mon,  6 Jan 2020 19:19:55 -0300 (-03)
Date:   Mon, 6 Jan 2020 19:19:55 -0300
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     rostedt@goodmis.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        arnaldo.melo@gmail.com, linux-kernel@vger.kernel.org,
        linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH] libtraceevent: Add dependency on libdl
Message-ID: <20200106221955.GC16851@kernel.org>
References: <20191226224931.3458-1-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191226224931.3458-1-sudipm.mukherjee@gmail.com>
X-Url:  http://acmel.wordpress.com
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Em Thu, Dec 26, 2019 at 10:49:31PM +0000, Sudip Mukherjee escreveu:
> event-plugin.c is calling dl_*() functions but it is not linked with
> libdl. As a result when we use ldd on the generated libtraceevent.so
> file, it does not list libdl as one of its dependencies.
> Add -ldl explicitly as done in tools/lib/lockdep.

Rostedt, can you ack this one? It applies just fine.

- Arnaldo
 
> Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> ---
>  tools/lib/traceevent/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/Makefile b/tools/lib/traceevent/Makefile
> index c874c017c636..0d0575981cc7 100644
> --- a/tools/lib/traceevent/Makefile
> +++ b/tools/lib/traceevent/Makefile
> @@ -143,7 +143,7 @@ $(TE_IN): force
>  	$(Q)$(MAKE) $(build)=libtraceevent
>  
>  $(OUTPUT)libtraceevent.so.$(EVENT_PARSE_VERSION): $(TE_IN)
> -	$(QUIET_LINK)$(CC) --shared $(LDFLAGS) $^ -Wl,-soname,libtraceevent.so.$(EP_VERSION) -o $@
> +	$(QUIET_LINK)$(CC) --shared $(LDFLAGS) $^ -ldl -Wl,-soname,libtraceevent.so.$(EP_VERSION) -o $@
>  	@ln -sf $(@F) $(OUTPUT)libtraceevent.so
>  	@ln -sf $(@F) $(OUTPUT)libtraceevent.so.$(EP_VERSION)
>  
> -- 
> 2.11.0

-- 

- Arnaldo
