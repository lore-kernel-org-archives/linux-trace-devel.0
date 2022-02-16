Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83B3C433FE
	for <linux-trace-devel@archiver.kernel.org>; Wed, 16 Feb 2022 16:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236527AbiBPQrf (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Wed, 16 Feb 2022 11:47:35 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236599AbiBPQrf (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 16 Feb 2022 11:47:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88637279088
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 08:47:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CE6961B87
        for <linux-trace-devel@vger.kernel.org>; Wed, 16 Feb 2022 16:47:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EE2C004E1;
        Wed, 16 Feb 2022 16:47:21 +0000 (UTC)
Date:   Wed, 16 Feb 2022 11:47:19 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tzvetomir Stoyanov <tz.stoyanov@gmail.com>
Cc:     Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] trace-cmd library: Do not record TSC frac bits if
 scaling is default
Message-ID: <20220216114719.47b819ca@gandalf.local.home>
In-Reply-To: <CAPpZLN7K+ouw+4p3eBAKObz-7Ao3+xD=vE4psWrhgYoK7jD_6Q@mail.gmail.com>
References: <20211210115508.103569-1-tz.stoyanov@gmail.com>
        <CAPpZLN7K+ouw+4p3eBAKObz-7Ao3+xD=vE4psWrhgYoK7jD_6Q@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Feb 2022 17:43:46 +0200
Tzvetomir Stoyanov <tz.stoyanov@gmail.com> wrote:

> ping
> Just to remind, this one is an important bugfix. It fixes host-guest
> tracing with the latest kernels, where new KVM debug info is exposed
> through the debugfs.

Hi Tzvetomir,

It's actually already in my local queue. I just haven't had a chance to
push it up yet.

Thanks,

-- Steve
