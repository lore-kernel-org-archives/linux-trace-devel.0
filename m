Return-Path: <SRS0=Mn5y=NN=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:36178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbeKCEZF (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Sat, 3 Nov 2018 00:25:05 -0400
Date: Fri, 2 Nov 2018 15:16:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 0/8] This series of patches contains various independent
Message-ID: <20181102151641.4eaa0cf2@gandalf.local.home>
In-Reply-To: <20181101214512.18684-1-ykaradzhov@vmware.com>
References: <20181101214512.18684-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 1 Nov 2018 21:45:36 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> Yordan Karadzhov (8):
>   kernel-shark-qt: Free all collections when closing the trace file.
>   kernel-shark-qt: Fix potential memory leak when searching in
>     collections
>   kernel-shark-qt: Put error messages always on top
>   kernel-shark-qt: Fix bug when loading the Dual Marker
>   kernel-shark-qt: Fix bug when loading plugins from session
>   kernel-shark-qt: Fix bug when resizing the KS window for session
>   kernel-shark-qt: Change the color convention of the task graphs
>   kernel-shark-qt: Remove duplicate code in KsWidgetsLib.cpp
> 
>  kernel-shark-qt/examples/dataplot.cpp |  30 +++--
>  kernel-shark-qt/src/KsGLWidget.cpp    |  15 ++-
>  kernel-shark-qt/src/KsGLWidget.hpp    |   2 +
>  kernel-shark-qt/src/KsMainWindow.cpp  |  12 +-
>  kernel-shark-qt/src/KsMainWindow.hpp  |  10 +-
>  kernel-shark-qt/src/KsPlotTools.cpp   | 152 ++++++++++++++++----------
>  kernel-shark-qt/src/KsPlotTools.hpp   |  45 ++++++--
>  kernel-shark-qt/src/KsSession.cpp     |  46 +++++---
>  kernel-shark-qt/src/KsSession.hpp     |   4 +-
>  kernel-shark-qt/src/KsWidgetsLib.cpp  |  28 ++---
>  kernel-shark-qt/src/libkshark-model.c |   8 +-
>  kernel-shark-qt/src/libkshark.c       |   7 ++
>  12 files changed, 233 insertions(+), 126 deletions(-)
> 

Pull. Thanks Yordan!

-- Steve
