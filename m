Return-Path: <SRS0=CcWV=UL=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D49C31E46
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 13:34:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D5562208CA
	for <linux-trace-devel@archiver.kernel.org>; Wed, 12 Jun 2019 13:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbfFLNez (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 12 Jun 2019 09:34:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:55532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726747AbfFLNez (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 12 Jun 2019 09:34:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94D5D20866;
        Wed, 12 Jun 2019 13:34:54 +0000 (UTC)
Date:   Wed, 12 Jun 2019 09:34:53 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Yordan Karadzhov <ykaradzhov@vmware.com>
Cc:     linux-trace-devel@vger.kernel.org, y.karadz@gmail.com,
        troyengel@gmail.com
Subject: Re: [PATCH 0/2] KernelShark build fixes for v1.0
Message-ID: <20190612093453.0eefe822@gandalf.local.home>
In-Reply-To: <20190611152043.22572-1-ykaradzhov@vmware.com>
References: <20190611152043.22572-1-ykaradzhov@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 11 Jun 2019 18:20:41 +0300
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> Two patches addressing the problem of having the paths to the build
> directory embedded in the final binaries. The problem was reported
> by Troy Engel.

Hi Troy,

Do these patches work for you?

 https://patchwork.kernel.org/patch/10987563/
 https://patchwork.kernel.org/patch/10987565/

If so, can I add our "Tested-by"?

Thanks!

-- Steve

> 
> Yordan Karadzhov (2):
>   kernel-shark: Avoid TRACECMD_BIN_DIR being set to the build path
>   kernel-shark: Avoid debug build when CMAKE_BUILD_TYPE=Release
> 
>  kernel-shark/CMakeLists.txt           | 25 ++++++++++++++++---------
>  kernel-shark/README                   |  4 ++--
>  kernel-shark/build/FindTraceCmd.cmake | 14 +++++++++-----
>  kernel-shark/build/deff.h.cmake       |  2 +-
>  kernel-shark/src/KsCaptureDialog.cpp  | 13 ++++++++-----
>  5 files changed, 36 insertions(+), 22 deletions(-)
> 

