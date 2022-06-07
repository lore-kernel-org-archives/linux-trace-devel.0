Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC094C43334
	for <linux-trace-devel@archiver.kernel.org>; Tue,  7 Jun 2022 10:02:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239844AbiFGKCL (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 7 Jun 2022 06:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240483AbiFGKCD (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 7 Jun 2022 06:02:03 -0400
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BA3585EE5
        for <linux-trace-devel@vger.kernel.org>; Tue,  7 Jun 2022 03:01:59 -0700 (PDT)
Received: from maia.denx.de (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: hws@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id B6D768430F;
        Tue,  7 Jun 2022 12:01:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1654596116;
        bh=qw6JwKbywEK9TpYtg2Qqz8PKdx6FzJ87HwewwXCYQb8=;
        h=Subject:From:To:Date:In-Reply-To:References:From;
        b=QF/HC0z4hZPA46HIxLmURoI+tvVeeTMqqbCLRhDEDbn5u4AB6l/GB9AYZodARNw1f
         9WWnpyKRpuazlXhO0VSK0plKMNsCVQpNvtEZ+fbdOjIh5wTE2b6AT5MgZmfD0Krrmr
         aHUKisqaDxVlBVuHxmWUj35A6Ga/UMw1g7p9I3NPxZ6mCpHJNf2kl1tqDo9EK+9bV+
         4CnPVhGy77B9qPwd2XvzTUF3s8MC0k2jHZZXMu7CvehK0XruRx48srLvm+TwCjEng3
         dsPrYd2py1u8K5fIR2vD5vkUKnVwQYsRGAOfy4XJI+yii2GZBLZNqTKHqIl2qs2aQt
         HOTQqIGe/ih5Q==
Message-ID: <7f97718f4f23603c08baba8f801a688d5a41448b.camel@denx.de>
Subject: Re: [PATCH 0/6] libtracefs: Fixes for sqlhist
From:   Harald Seiler <hws@denx.de>
To:     Steven Rostedt <rostedt@goodmis.org>,
        linux-trace-devel@vger.kernel.org
Date:   Tue, 07 Jun 2022 12:01:56 +0200
In-Reply-To: <20220606192953.334315-1-rostedt@goodmis.org>
References: <20220606192953.334315-1-rostedt@goodmis.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 (3.42.4-2.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

Hi,

On Mon, 2022-06-06 at 15:29 -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> At Kernel Recipes, I demonstrated sqlhist and how to use it. Along the way,
> I discovered several bugs. This series addresses those bugs that were found.

For the whole series:

Tested-by: Harald Seiler <hws@denx.de>

As a sanity check I accumulated offcpu time for a process:

	sqlhist -e -n 'offcpu' 'SELECT start.prev_comm AS comm, (end.TIMESTAMP_USECS - start.TIMESTAMP_USECS) as lat FROM sched_switch as start JOIN sched_switch as end ON start.prev_pid == end.next_pid WHERE start.prev_comm == "ping"'
	echo "hist:keys=comm:vals=lat:sort=lat" >/sys/kernel/tracing/events/synthetic/offcpu/trigger

And then verified the collected time is consistent by comparing with
getrusage(2) values for the process (as returned by time(1)).

And indeed,

	wall_time == ru_utime + ru_stime + lat

So it is measuring exactly what I want.

Thanks again for getting this working!

> Steven Rostedt (Google) (6):
>   libtracefs: Fix make sqlhist when built again
>   libtracefs: Add libtracefs.a to dependency of sqlhist
>   libtracefs: Differentiate FROM and JOIN events if they are the same
>     event
>   libtracefs: Use unique names for sql field variables
>   libtracefs: Differentiate WHERE clause when FROM and TO events are the
>     same
>   libtracefs sqlhist: Report errors executing the commands
> 
>  Documentation/libtracefs-sql.txt |  18 ++++--
>  include/tracefs-local.h          |   4 ++
>  samples/Makefile                 |   4 +-
>  src/sqlhist-parse.h              |   3 +-
>  src/tracefs-hist.c               | 105 ++++++++++++++++++++++++++++---
>  src/tracefs-sqlhist.c            |  44 +++++++++----
>  6 files changed, 150 insertions(+), 28 deletions(-)
> 

-- 
Harald
