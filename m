Return-Path: <SRS0=9Vts=OG=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:44644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbeK1KCO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 28 Nov 2018 05:02:14 -0500
Date: Tue, 27 Nov 2018 18:02:45 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 00/11] Small modifications and bug fixes toward KS 1.0
Message-ID: <20181127180245.19630397@gandalf.local.home>
In-Reply-To: <20181121151356.16901-1-ykaradzhov@vmware.com>
References: <20181121151356.16901-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 21 Nov 2018 15:14:17 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> This series of patches contains various independent modifications and
> bug fixes needed before releasing KernelShark 1.0.
> 
> Yordan Karadzhov (11):
>   kernel-shark-qt: Protect all calls of tep_read_number_field()
>   kernel-shark-qt: Fix the returned error value of
>     kshark_get_event_id_easy()
>   kernel-shark-qt: Avoid race condition in kshark_get_event_name_easy()
>   kernel-shark-qt: Optimize the search in the text data
>   kernel-shark-qt: Add iterator index to the search panel
>   kernel-shark-qt: Update search iterator when marker is changed
>   kernel-shark-qt: Optimize the search in a case of a small data-set
>   kernel-shark qt: No error when Record authentication dialog is closed
>   kernel-shark-qt: Remove all system=ftrace events from Record dialog

I applied patches 2, 4, 5, 6, 7, and 9 which are:

 kernel-shark-qt: Fix the returned error value of kshark_get_event_id_easy()
 kernel-shark-qt: Optimize the search in the text data
 kernel-shark-qt: Add iterator index to the search panel
 kernel-shark-qt: Update search iterator when marker is changed
 kernel-shark-qt: Optimize the search in a case of a small data-set
 kernel-shark-qt: Remove all system=ftrace events from Record dialog

The rest I commented on.

>   kernel-shark-qt: Updata Event filter mask when applaing filters to
>     Graph
>   kernel-shark-qt: Reprocess all CPU collections when the filtering
>     changes

The above two I never received ?

-- Steve

> 
>  kernel-shark-qt/src/KsCaptureDialog.cpp    |   1 +
>  kernel-shark-qt/src/KsMainWindow.cpp       |   8 ++
>  kernel-shark-qt/src/KsModels.cpp           |  28 ++--
>  kernel-shark-qt/src/KsModels.hpp           |   4 +-
>  kernel-shark-qt/src/KsTraceViewer.cpp      | 152 +++++++++++++++------
>  kernel-shark-qt/src/KsTraceViewer.hpp      |   9 +-
>  kernel-shark-qt/src/KsUtils.cpp            |   6 +
>  kernel-shark-qt/src/KsWidgetsLib.cpp       |  10 ++
>  kernel-shark-qt/src/KsWidgetsLib.hpp       |   2 +
>  kernel-shark-qt/src/libkshark.c            |  15 +-
>  kernel-shark-qt/src/plugins/sched_events.c |  52 ++++---
>  11 files changed, 204 insertions(+), 83 deletions(-)
> 
