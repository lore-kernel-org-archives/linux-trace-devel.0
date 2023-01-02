Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CDC1C4167B
	for <linux-trace-devel@archiver.kernel.org>; Mon,  2 Jan 2023 08:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjABIw5 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 2 Jan 2023 03:52:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjABIw4 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 2 Jan 2023 03:52:56 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7B472666
        for <linux-trace-devel@vger.kernel.org>; Mon,  2 Jan 2023 00:52:55 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 705B52074A;
        Mon,  2 Jan 2023 08:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1672649574; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8aIEkgpI0cDwaYWt6aH5xyh/JRACO7JWq9VnpwhTxPE=;
        b=ElkZR547L/x0N445couhnMSIulQdkko5yI10ghWpxIWLxdyS6nMQLToWMZti9ik3dCSTbs
        dIkNshUyglK+4E9e2Y8Boh7+DlGX88H7w4BUnzFv0WvoYOpSNhtiglg7cNJc7JHw0ri+ZV
        tdDgzSEzKywXZg9S5rKsF88aDmAr3t0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1672649574;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8aIEkgpI0cDwaYWt6aH5xyh/JRACO7JWq9VnpwhTxPE=;
        b=Kwu779p5t19APayjdOz2ZmL1zohWBzmF4kBTLX7DbfUP1XY6wLrGBVcirNXwepq69bHppC
        PLZYAe2HkRYwQ/Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 628C213427;
        Mon,  2 Jan 2023 08:52:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id m1gHGGabsmMlLgAAMHmgww
        (envelope-from <dwagner@suse.de>); Mon, 02 Jan 2023 08:52:54 +0000
Date:   Mon, 2 Jan 2023 09:52:53 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Michal Sojka <michal.sojka@cvut.cz>
Cc:     linux-trace-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] trace-cmd: Allow building with GNU Make 4.4
Message-ID: <20230102085253.jpnwmwo72jfkzznc@carbon>
References: <20221226164951.2632069-1-michal.sojka@cvut.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221226164951.2632069-1-michal.sojka@cvut.cz>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi Michal,

On Mon, Dec 26, 2022 at 05:49:51PM +0100, Michal Sojka wrote:
> Make 4.4 introduces several backward incompatibilities and the result
> is that building trace-cmd with it never finishes. It seems that make
> ends up in some kind of infinite recursion. The symptoms are:
> 
>     $ make -d
>     GNU Make 4.4
>     Built for x86_64-pc-linux-gnu
>     Copyright (C) 1988-2022 Free Software Foundation, Inc.
>     License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>
>     This is free software: you are free to change and redistribute it.
>     There is NO WARRANTY, to the extent permitted by law.
>     Reading makefiles...
>     Reading makefile 'Makefile'...
>     Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
>     Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
>     Makefile:224: not recursively expanding LIBTRACECMD_SHARED_VERSION to export to shell function
>     Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
>     Makefile:224: not recursively expanding LIBTRACECMD_SHARED_VERSION to export to shell function
>     Makefile:225: not recursively expanding LIBTRACECMD_SHARED_SO to export to shell function
>     Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
>     Makefile:79: not recursively expanding pkgconfig_dir to export to shell function
> 
> Build succeeds if recursively expanded variables (defined with '='),
> which use $(shell ...) as its value, are replaced with simply expanded
> variables (defined with ':=').
> 
> Signed-off-by: Michal Sojka <michal.sojka@cvut.cz>

This seems to address my make troubles. I am again able to build trace-cmd with make v4.4. Thanks!

Tested-by: Daniel Wagner <dwagner@suse.de>

> ---
>  Makefile | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)
> 
> diff --git a/Makefile b/Makefile
> index bda49dd..d50e625 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -221,8 +221,8 @@ LIBS ?= -ldl
>  LIBTRACECMD_DIR = $(obj)/lib/trace-cmd
>  LIBTRACECMD_STATIC = $(LIBTRACECMD_DIR)/libtracecmd.a
>  LIBTRACECMD_SHARED = $(LIBTRACECMD_DIR)/libtracecmd.so.$(LIBTRACECMD_VERSION)
> -LIBTRACECMD_SHARED_VERSION = $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\.[0-9]*\).*/\1/')
> -LIBTRACECMD_SHARED_SO = $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\).*/\1/')
> +LIBTRACECMD_SHARED_VERSION := $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\.[0-9]*\).*/\1/')
> +LIBTRACECMD_SHARED_SO := $(shell echo $(LIBTRACECMD_SHARED) | sed -e 's/\(\.so\).*/\1/')
>  
>  export LIBTRACECMD_STATIC LIBTRACECMD_SHARED
>  export LIBTRACECMD_SHARED_VERSION LIBTRACECMD_SHARED_SO
> @@ -230,12 +230,12 @@ export LIBTRACECMD_SHARED_VERSION LIBTRACECMD_SHARED_SO
>  LIBTRACEEVENT=libtraceevent
>  LIBTRACEFS=libtracefs
>  
> -TEST_LIBTRACEEVENT = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEEVENT_MIN_VERSION) $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
> -TEST_LIBTRACEFS = $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEFS_MIN_VERSION) $(LIBTRACEFS) > /dev/null 2>&1 && echo y")
> +TEST_LIBTRACEEVENT := $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEEVENT_MIN_VERSION) $(LIBTRACEEVENT) > /dev/null 2>&1 && echo y")
> +TEST_LIBTRACEFS := $(shell sh -c "$(PKG_CONFIG) --atleast-version $(LIBTRACEFS_MIN_VERSION) $(LIBTRACEFS) > /dev/null 2>&1 && echo y")
>  
>  ifeq ("$(TEST_LIBTRACEEVENT)", "y")
> -LIBTRACEEVENT_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
> -LIBTRACEEVENT_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEEVENT)")
> +LIBTRACEEVENT_CFLAGS := $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEEVENT)")
> +LIBTRACEEVENT_LDLAGS := $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEEVENT)")
>  else
>  .PHONY: warning
>  warning:
> @@ -253,8 +253,8 @@ endif
>  export LIBTRACEEVENT_CFLAGS LIBTRACEEVENT_LDLAGS
>  
>  ifeq ("$(TEST_LIBTRACEFS)", "y")
> -LIBTRACEFS_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS)")
> -LIBTRACEFS_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEFS)")
> +LIBTRACEFS_CFLAGS := $(shell sh -c "$(PKG_CONFIG) --cflags $(LIBTRACEFS)")
> +LIBTRACEFS_LDLAGS := $(shell sh -c "$(PKG_CONFIG) --libs $(LIBTRACEFS)")
>  else
>  .PHONY: warning
>  warning:
> @@ -324,11 +324,11 @@ endif
>  export ZLIB_LDLAGS
>  
>  ifndef NO_LIBZSTD
> -TEST_LIBZSTD = $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.4.0 libzstd > /dev/null 2>&1 && echo y")
> +TEST_LIBZSTD := $(shell sh -c "$(PKG_CONFIG) --atleast-version 1.4.0 libzstd > /dev/null 2>&1 && echo y")
>  
>  ifeq ("$(TEST_LIBZSTD)", "y")
> -LIBZSTD_CFLAGS = $(shell sh -c "$(PKG_CONFIG) --cflags libzstd")
> -LIBZSTD_LDLAGS = $(shell sh -c "$(PKG_CONFIG) --libs libzstd")
> +LIBZSTD_CFLAGS := $(shell sh -c "$(PKG_CONFIG) --cflags libzstd")
> +LIBZSTD_LDLAGS := $(shell sh -c "$(PKG_CONFIG) --libs libzstd")
>  CFLAGS += -DHAVE_ZSTD
>  ZSTD_INSTALLED=1
>  $(info    Have ZSTD compression support)
> -- 
> 2.38.1
> 
