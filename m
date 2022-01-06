Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C225FC433F5
	for <linux-trace-devel@archiver.kernel.org>; Thu,  6 Jan 2022 17:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241570AbiAFRTA (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 12:19:00 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:45404 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241639AbiAFRTA (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 12:19:00 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 758ECCE2659
        for <linux-trace-devel@vger.kernel.org>; Thu,  6 Jan 2022 17:18:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF94C36AEB;
        Thu,  6 Jan 2022 17:18:56 +0000 (UTC)
Date:   Thu, 6 Jan 2022 12:18:54 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Hongzhan Chen <hongzhan.chen@intel.com>
Cc:     linux-trace-devel@vger.kernel.org,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH v2 0/2]kernel-shark:add new plugin for xenomai
 cobalt_switch_context events
Message-ID: <20220106121854.106d5b27@gandalf.local.home>
In-Reply-To: <20211222064014.4471-1-hongzhan.chen@intel.com>
References: <20211222064014.4471-1-hongzhan.chen@intel.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org


This was sent during the Christmas vacation. I don't want it to be
forgotten about.

Yordan, what's your thoughts on this?

-- Steve


On Wed, 22 Dec 2021 01:40:12 -0500
Hongzhan Chen <hongzhan.chen@intel.com> wrote:

> 1. To avoid code duplication, move some common APIs and definitions
>    out to create new files and share with other plugins.
> 2. add new plugin for handling xenomai cobalt_switch_context events
>    to visualize OOB state of RT tasks.
> 
> I tried to move common APIs and definitions to KsPlugins.cpp/hpp but
> found these definitions finally depend on KsMainWindow object used
> by _doubleClick of LatencyBox assigned by plugin_set_gui_ptr via
> KSHARK_MENU_PLUGIN_INITIALIZER. 
> I do not know how to remove this dependency so I create new files to
> avoid code duplication. Please suggest if there is better way. 
> 
> Hongzhan Chen (2):
>   kernel-shark: Move common APIs and definitions out to avoid
>     duplication
>   kernel-shark: Add plugin for handling Xenomai cobalt_context_switch
> 
>  src/libkshark-tepdata.c                    |   1 +
>  src/plugins/CMakeLists.txt                 |   6 +-
>  src/plugins/CobaltSwitchEvents.cpp         | 125 +++++++++++++++
>  src/plugins/CommonSched.hpp                |  99 ++++++++++++
>  src/plugins/SchedEvents.cpp                |  87 +----------
>  src/plugins/common_sched.c                 |  37 +++++
>  src/plugins/common_sched.h                 |  50 ++++++
>  src/plugins/sched_events.c                 |  37 +----
>  src/plugins/sched_events.h                 |  12 +-
>  src/plugins/xenomai_cobalt_switch_events.c | 169 +++++++++++++++++++++
>  src/plugins/xenomai_cobalt_switch_events.h |  54 +++++++
>  11 files changed, 545 insertions(+), 132 deletions(-)
>  create mode 100644 src/plugins/CobaltSwitchEvents.cpp
>  create mode 100644 src/plugins/CommonSched.hpp
>  create mode 100644 src/plugins/common_sched.c
>  create mode 100644 src/plugins/common_sched.h
>  create mode 100644 src/plugins/xenomai_cobalt_switch_events.c
>  create mode 100644 src/plugins/xenomai_cobalt_switch_events.h
> 

