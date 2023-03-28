Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97ABDC76196
	for <linux-trace-devel@archiver.kernel.org>; Tue, 28 Mar 2023 15:15:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233064AbjC1PPL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 28 Mar 2023 11:15:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232918AbjC1PO5 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 28 Mar 2023 11:14:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82DA910278
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 08:14:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91919B81C24
        for <linux-trace-devel@vger.kernel.org>; Tue, 28 Mar 2023 15:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E07ECC433EF;
        Tue, 28 Mar 2023 15:13:32 +0000 (UTC)
Date:   Tue, 28 Mar 2023 11:13:31 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 0/3] Introduce new API to reset ftrace instance
Message-ID: <20230328111331.1e9cb292@gandalf.local.home>
In-Reply-To: <20230328150308.34783-1-tz.stoyanov@gmail.com>
References: <20230328150308.34783-1-tz.stoyanov@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Tue, 28 Mar 2023 18:03:05 +0300
"Tzvetomir Stoyanov (VMware)" <tz.stoyanov@gmail.com> wrote:

> A new API tracefs_instance_reset() for resetting instance to its default
> state, based on the logic from "trace-cmd reset" command.

HAH!!!

I was just thinking that I needed to implement this earlier today.

I'm so happy when someone else does my work for me :-D

Thanks Tzvetomir, I'll hopefully get a chance to review this sometime this
week.

-- Steve

> 
> Tzvetomir Stoyanov (VMware) (3):
>   libtracefs: New API to reset ftrace instance
>   libtracefs: Documentation for tracefs_instance_reset()
>   libtracefs: Unit test for tracefs_instance_reset()
> 
>  Documentation/libtracefs-instances-manage.txt |   7 +-
>  Documentation/libtracefs.txt                  |   1 +
>  include/tracefs-local.h                       |   1 +
>  include/tracefs.h                             |   1 +
>  src/tracefs-instance.c                        | 196 ++++++++++++++++++
>  src/tracefs-utils.c                           |  20 ++
>  utest/tracefs-utest.c                         | 183 ++++++++++++++++
>  7 files changed, 407 insertions(+), 2 deletions(-)
> 

