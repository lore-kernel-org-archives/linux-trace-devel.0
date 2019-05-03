Return-Path: <SRS0=scwk=TD=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2DEEC43219
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 23:06:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CE04E2075E
	for <linux-trace-devel@archiver.kernel.org>; Fri,  3 May 2019 23:06:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbfECXGA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 3 May 2019 19:06:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbfECXGA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 3 May 2019 19:06:00 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F07B20644;
        Fri,  3 May 2019 23:05:59 +0000 (UTC)
Date:   Fri, 3 May 2019 19:05:57 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com, Slavomir Kaslev <kaslevs@vmware.com>
Subject: Re: [PATCH v2 3/8] kernel-shark: Add logic for the plugins search
 path
Message-ID: <20190503190557.6e36e59a@gandalf.local.home>
In-Reply-To: <20190502124009.32208-4-ykaradzhov@vmware.com>
References: <20190502124009.32208-1-ykaradzhov@vmware.com>
        <20190502124009.32208-4-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu,  2 May 2019 15:40:04 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> If the application has not been started from its installation location
> and the the directory
> 
>  app_file_path + "../../kernel-shark/lib"
> 
> exists, all build-in plugins will be loaded from this directory. In any
> other case all build-in plugins will be loaded from
> 
> _INSTALL_PREFIX/lib/kshark/plugins/
> 
> Suggested-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> Reviewed-by: Slavomir Kaslev <kaslevs@vmware.com>
> Signed-off-by: Yordan Karadzhov <ykaradzhov@vmware.com>
> ---
>  kernel-shark/src/KsUtils.cpp            | 40 ++++++++++++++++++-------
>  kernel-shark/src/KsUtils.hpp            |  2 ++
>  kernel-shark/src/plugins/CMakeLists.txt |  2 +-
>  3 files changed, 32 insertions(+), 12 deletions(-)
> 

Hi Yordan,

After applying this patch, kernelshark's behavior for loading trace.dat
changed. It no longer looks for the file in the current directory. If I
run:

 # trace-cmd record -e sched_switch sleep 1
 # kernelshark

It loads without loading the produced trace.dat.

If I run:

 # kernelshark trace.dat

I get an error message stating:

 "Unable to find file trace.dat"

-- Steve
