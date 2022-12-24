Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A54BC4332F
	for <linux-trace-devel@archiver.kernel.org>; Sat, 24 Dec 2022 15:32:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbiLXPca (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Sat, 24 Dec 2022 10:32:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231277AbiLXPc3 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 24 Dec 2022 10:32:29 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E3DC75F
        for <linux-trace-devel@vger.kernel.org>; Sat, 24 Dec 2022 07:32:27 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id BACB460995;
        Sat, 24 Dec 2022 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671895945; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=einIG3SHvX6Z+iar4lX7bhq8YKiE1HbbjUvTdvWDuTA=;
        b=196A1tCPVg9D8CGy3zZwmveUX7tgreSqxMRGhipgQXAEpS0WiNvAia8+j6xXqIY63/LUVE
        6uTyWxgWDWjFAHFcGrKNNOXu3DZ3ZIX0uK/aaXp3eMYMqZcCqB+SX2iWhkz8iRYVjcmL5t
        tVNVUvHXj5dgY6c/gGQ7uTn4PitJeNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671895945;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=einIG3SHvX6Z+iar4lX7bhq8YKiE1HbbjUvTdvWDuTA=;
        b=NxuLwXsm+PXkIuhzRHVQ3z6W53Ih74x2c8INZ2fzomj/NIxzB1P3zKyBThLNZk1lmz9BzE
        8xYBO0X7HB7oziDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id AE7D313489;
        Sat, 24 Dec 2022 15:32:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id /oGNKokbp2PyZAAAMHmgww
        (envelope-from <dwagner@suse.de>); Sat, 24 Dec 2022 15:32:25 +0000
Date:   Sat, 24 Dec 2022 16:32:25 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     linux-trace-devel@vger.kernel.org
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
Subject: Re: [PATCH v4] libtraceevent: Add initial support for meson
Message-ID: <20221224153225.ojre2c3fxktfxtj2@carbon.lan>
References: <20221220180840.32586-1-dwagner@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221220180840.32586-1-dwagner@suse.de>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, Dec 20, 2022 at 07:08:40PM +0100, Daniel Wagner wrote:
> Introduce Meson as build framework for building libtraceevent. This
> lives besides the Makefiles until all the expected initial fallouts
> have been dealed with.
> 
> The build steps are:
> 
>   # configure using .build as build directory and install destination
>   # /tmp/test
>   meson --prefix=/tmp/libtraceevent .build
> 
>   # trigger the build
>   ninja -C .build
> 
>   # install the library
>   ninja -C .build install
> 
> In case you want to build/install the documentation the setup is
> 
>   meson -Ddocs-build=true .build
> 
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
> v4:
>  - install man pages to correct section, in this case 3

During my packaging attempt I found out that the man pages are installed
into subdirs. So I started to look into the this and ... let's say it's
complicated.

For example libtraceevent-func_apis.txt list a few function which are
also listed in libtraceevent-func_find.txt. The Makefile uses these
function as build names but, if we have two targets with the same name
one will overwrite the other. make seems to tolerate something like
this. Meson doesn't.

I am playing with various ideas how we could handle this. Currently, I
think the best way is to distinguish the different source txt files. So
we have files which are for generating a mans per function (1:n)
and we have txt files which are general documentation (1:1).
