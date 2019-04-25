Return-Path: <SRS0=Y1eu=S3=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E369DC43219
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 16:34:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51CF22088F
	for <linux-trace-devel@archiver.kernel.org>; Thu, 25 Apr 2019 16:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbfDYQei (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 12:34:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:35906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725941AbfDYQei (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 12:34:38 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C7D320717;
        Thu, 25 Apr 2019 16:34:38 +0000 (UTC)
Date:   Thu, 25 Apr 2019 12:34:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Alan Mikhak <amikhak@wirelessfabric.com>
Cc:     ykaradzhov@vmware.com,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] Compile kernel-shark with -fPIC option
Message-ID: <20190425123436.4973bfa4@gandalf.local.home>
In-Reply-To: <1556209669-2610-1-git-send-email-amikhak@wirelessfabric.com>
References: <1556209669-2610-1-git-send-email-amikhak@wirelessfabric.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


Hi Alan,

Thanks for the patch. FYI, it's best to also Cc
linux-trace-devel@vger.kernel.org when sending patches.

On Thu, 25 Apr 2019 09:27:49 -0700
Alan Mikhak <amikhak@wirelessfabric.com> wrote:

> From: Alan Mikhak <amikhak@wirelessfabric.com>
> 
> Resolve linker relocation error when linking libkshark.so.0.9.8
> with cmake on armv7l, aarch64, and some x86_64 platforms.
> 
> Ubuntu 16.04 (xenial) on x86_64:
> relocation R_X86_64_32 against `.rodata.str1.1' can not be used when
> making a shared object; recompile with -fPIC
> 
> Debian 9.8 (stretch) on x86_64:
> relocation R_X86_64_TPOFF32 against `seq' can not be used when making
> a shared object; recompile with -fPIC
> 
> Signed-off-by: Alan Mikhak <amikhak@wirelessfabric.com>
> ---
>  kernel-shark/CMakeLists.txt | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 1aee858..ac17642 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -32,8 +32,8 @@ endif (Qt5Widgets_FOUND)
>  set(LIBRARY_OUTPUT_PATH    "${KS_DIR}/lib")
>  set(EXECUTABLE_OUTPUT_PATH "${KS_DIR}/bin")
>  
> -set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -g -pthread")
> -set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -std=c++11 -pthread")
> +set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS} -Wall -g -pthread -fPIC")
> +set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -g -std=c++11 -pthread -fPIC")

Yordan,

Can you take a look at this patch and add a Reviewed-by tag if you are
good with it?

-- Steve

>  
>  if(NOT _INSTALL_PREFIX)
>  	set(_INSTALL_PREFIX "/usr/local")

