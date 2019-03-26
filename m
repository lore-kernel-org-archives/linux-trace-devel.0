Return-Path: <SRS0=md0U=R5=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6BEDC43381
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:51:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9AE8E20896
	for <linux-trace-devel@archiver.kernel.org>; Tue, 26 Mar 2019 20:51:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732727AbfCZUv2 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:51:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732716AbfCZUv2 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 26 Mar 2019 16:51:28 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F4E22087C;
        Tue, 26 Mar 2019 20:51:27 +0000 (UTC)
Date:   Tue, 26 Mar 2019 16:51:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] kernel-shark: Configuration information in
 ${HOME}/.cache/kernelshark
Message-ID: <20190326165125.5537384d@gandalf.local.home>
In-Reply-To: <20190313152220.22026-3-ykaradzhov@vmware.com>
References: <20190313152220.22026-1-ykaradzhov@vmware.com>
        <20190313152220.22026-3-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 13 Mar 2019 17:22:19 +0200
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> @@ -12,10 +12,12 @@ message("\n project: Kernel Shark: (version: ${KS_VERSION_STRING})\n")
>  
>  set(KS_DIR ${CMAKE_SOURCE_DIR})
>  
> -# Make a directory to hold configuration files. To change this do:
> -# cmake .. -DKS_CONF_DIR=/your/preferred/path
> -set(KS_CONF_DIR "${KS_DIR}/.ksconf" CACHE STRING "Directory for configuration files.")
> -file(MAKE_DIRECTORY ${KS_CONF_DIR})
> +# Make a directory to hold cached configuration files. To change this do:
> +# cmake .. -DKS_CACHE_DIR=/your/preferred/path
> +set(KS_CACHE_DIR "$ENV{HOME}/.cache/kernelshark"
> +    CACHE STRING "Directory for cached configuration files.")
> +
> +file(MAKE_DIRECTORY ${KS_CACHE_DIR})
>  

This time I'm not confused (I tried it out).

The build process should *not* make the .cache/kernelshark directory.
It should be made by the application, just like all other applications
do.

-- Steve
