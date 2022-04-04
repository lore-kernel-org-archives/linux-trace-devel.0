Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4742C433F5
	for <linux-trace-devel@archiver.kernel.org>; Mon,  4 Apr 2022 21:28:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379519AbiDDVaC (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 4 Apr 2022 17:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379995AbiDDSg2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 4 Apr 2022 14:36:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26C8F31376
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 11:34:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B41CB60DE1
        for <linux-trace-devel@vger.kernel.org>; Mon,  4 Apr 2022 18:34:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D68CC2BBE4;
        Mon,  4 Apr 2022 18:34:29 +0000 (UTC)
Date:   Mon, 4 Apr 2022 14:34:27 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-trace-devel@vger.kernel.org, vineethrp@google.com,
        tz.stoyanov@gmail.com
Subject: Re: [PATCH v2] trace-cmd: Move trace_msg cache file to memfd
Message-ID: <20220404143427.091a26bb@gandalf.local.home>
In-Reply-To: <20220403231825.1258376-1-joel@joelfernandes.org>
References: <20220403231825.1258376-1-joel@joelfernandes.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Sun,  3 Apr 2022 23:18:25 +0000
Joel Fernandes <joel@joelfernandes.org> wrote:

> +++ b/lib/trace-cmd/trace-msg.c
> @@ -593,11 +593,9 @@ tracecmd_msg_handle_alloc(int fd, unsigned long flags)
>  int tracecmd_msg_handle_cache(struct tracecmd_msg_handle *msg_handle)
>  {
>  	if (msg_handle->cfd < 0) {
> -		strcpy(msg_handle->cfile, MSG_CACHE_FILE);
> -		msg_handle->cfd = mkstemp(msg_handle->cfile);
> +		msg_handle->cfd = memfd_create("trace_msg_cache", 0);
>  		if (msg_handle->cfd < 0)
>  			return -1;
> -		unlink(msg_handle->cfile);
>  	}

This causes:

trace-profile.c:23:3: warning: #warning "lib audit not found, using raw syscalls " "(install audit-libs-devel(for fedora) or libaudit-dev(for debian/ubuntu) and try again)" [-Wcpp]
   23 | # warning "lib audit not found, using raw syscalls "    \
      |   ^~~~~~~


Care to send a v3 update?

Man page shows:

SYNOPSIS
       #define _GNU_SOURCE         /* See feature_test_macros(7) */
       #include <sys/mman.h>

       int memfd_create(const char *name, unsigned int flags);

Note, all of trace-cmd is compiled with _GNU_SOURCE set.

-- Steve
