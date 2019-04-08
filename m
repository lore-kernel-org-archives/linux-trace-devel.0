Return-Path: <SRS0=kFh5=SK=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD6A2C10F14
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:03:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4B8C21473
	for <linux-trace-devel@archiver.kernel.org>; Mon,  8 Apr 2019 15:03:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727881AbfDHPDN (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 8 Apr 2019 11:03:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53788 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727835AbfDHPDN (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 8 Apr 2019 11:03:13 -0400
Received: by mail-wm1-f67.google.com with SMTP id q16so14774515wmj.3
        for <linux-trace-devel@vger.kernel.org>; Mon, 08 Apr 2019 08:03:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=g8e5plwPMjMqo9BsyLzkyg0ehzsfht0BwN6dwWljPF8=;
        b=U62cdT0jKjnyrCBOWpOEq0gVxGRrU+uhGJ29kMaBa4SY6HSTzjwokUw7+ohDxuqa0B
         wFyK6xe5W72ovJAlADQ3yMBqcAkfnFT5q61rsQ1k2YkTfnwX9/uOq47YAeU7R6zwim7I
         27f0Mux1NPAaWJNPdOIhmaNbtc9LErXYFC2nC9uITAARiztCeH96BiWShSuhdqljKC1a
         Q/v6OwIwdAYUrAhKW+dEz0alb5zJ0i8tW5HHoGkvjCyqO6PVfCEhAFvUAFEwvWzIKNKd
         uc6nn+zn1N7Khxzydwh/bLVWscHUORoakNfM2Y7+w8KMEuURIk5rrgQFSunxT3nE8OIc
         BZ8Q==
X-Gm-Message-State: APjAAAUQqfsz2XCAFVyVM016lJ+rqsr5UDcVqSmhM2C2h2JLCDqETHBi
        d/Yq+XsyOxPqc1LzmnkGAQ==
X-Google-Smtp-Source: APXvYqwWSOHKAq4jr1mIERlAnLXdh5CLm2CYOtNmmU1ODiNg310EpIQ+p5r7gysyr73FzKOoesqm5g==
X-Received: by 2002:a1c:df89:: with SMTP id w131mr15684062wmg.82.1554735791613;
        Mon, 08 Apr 2019 08:03:11 -0700 (PDT)
Received: from box ([146.247.46.6])
        by smtp.gmail.com with ESMTPSA id x192sm16468555wmf.48.2019.04.08.08.03.10
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Apr 2019 08:03:11 -0700 (PDT)
Date:   Mon, 8 Apr 2019 18:03:08 +0300
From:   Slavomir Kaslev <kaslevs@vmware.com>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     rostedt@goodmis.org, linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 4/4] kernel-shark: Configuration file directory to be
 created by the executable
Message-ID: <20190408150307.GB6430@box>
References: <20190404145603.13592-1-ykaradzhov@vmware.com>
 <20190404145603.13592-5-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190404145603.13592-5-ykaradzhov@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Apr 04, 2019 at 05:56:03PM +0300, Yordan Karadzhov wrote:
> The build process should not make the directory that will contain
> KernelShark configuration files. This directory should be made by
> the application itself.
> 
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/CMakeLists.txt       | 2 --
>  kernel-shark/src/KsMainWindow.cpp | 3 +++
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel-shark/CMakeLists.txt b/kernel-shark/CMakeLists.txt
> index 14d73f5..c6a4abf 100644
> --- a/kernel-shark/CMakeLists.txt
> +++ b/kernel-shark/CMakeLists.txt
> @@ -17,8 +17,6 @@ set(KS_DIR ${CMAKE_SOURCE_DIR})
>  set(_KS_CACHE_DIR "$ENV{HOME}/.cache/kernelshark"
>      CACHE STRING "Directory for cached configuration files.")
>  
> -file(MAKE_DIRECTORY ${_KS_CACHE_DIR})
> -
>  include(${KS_DIR}/build/FindTraceCmd.cmake)
>  include(${KS_DIR}/build/FindJSONC.cmake)
>  
> diff --git a/kernel-shark/src/KsMainWindow.cpp b/kernel-shark/src/KsMainWindow.cpp
> index 39b06d6..898e598 100644
> --- a/kernel-shark/src/KsMainWindow.cpp
> +++ b/kernel-shark/src/KsMainWindow.cpp
> @@ -127,6 +127,9 @@ KsMainWindow::KsMainWindow(QWidget *parent)
>  		this,		&KsMainWindow::_deselectB);
>  
>  	_resizeEmpty();
> +
> +	if (!QDir(KS_CACHE_DIR).exists())
> +		QDir().mkdir(KS_CACHE_DIR);
>  }

This should be QtDir().mkpath() since KS_CACHE_DIR is configurable and can be of
the form '/foo/bar/baz'.

Also this code doesn't handle the case when the cache dir is overriden by an
environment variable. I think it's better to move this to where we save the
session rather then here.

-- Slavi
