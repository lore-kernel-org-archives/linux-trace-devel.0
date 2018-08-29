Return-Path: <SRS0=cHGG=LM=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:50616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727204AbeH2RFp (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 29 Aug 2018 13:05:45 -0400
Date: Wed, 29 Aug 2018 09:08:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc: linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Add drawing instrumentation to be used by the
 Qt-based KernelShark
Message-ID: <20180829090851.15b2f1fd@gandalf.local.home>
In-Reply-To: <20180828130838.30790-1-y.karadz@gmail.com>
References: <20180828130838.30790-1-y.karadz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 28 Aug 2018 16:08:34 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> The KernelShark plotting library is introduced in this series of patches.
> The library will be used by the GUI to draw CPU and Task Graphs. This is
> also the first time KernelShark enters the world of C++.
> 
> This is the 3th version of this series of patches. The major change
> from v2 is the debugging of the example ([PATCH 3/4]).
> 
> Yordan Karadzhov (VMware) (4):
>   kernel-shark-qt: Add OpenGL/GLUT as a third party dependency.
>   kernel-shark-qt: Add basic instruments for OpenGL plotting.
>   kernel-shark-qt: Add C++ API for drawing of Graphs
>   kernel-shark-qt: Add an example showing how to draw shapes and Graphs.

I pulled these and pushed them to my repo.

Thanks Yordan!

-- Steve

> 
>  kernel-shark-qt/CMakeLists.txt          |    3 +
>  kernel-shark-qt/README                  |    2 +
>  kernel-shark-qt/examples/CMakeLists.txt |    4 +
>  kernel-shark-qt/examples/dataplot.cpp   |  231 +++++
>  kernel-shark-qt/src/CMakeLists.txt      |   14 +
>  kernel-shark-qt/src/KsPlotTools.cpp     | 1123 +++++++++++++++++++++++
>  kernel-shark-qt/src/KsPlotTools.hpp     |  485 ++++++++++
>  kernel-shark-qt/src/libkshark-plot.c    |  212 +++++
>  kernel-shark-qt/src/libkshark-plot.h    |   69 ++
>  9 files changed, 2143 insertions(+)
>  create mode 100644 kernel-shark-qt/examples/dataplot.cpp
>  create mode 100644 kernel-shark-qt/src/KsPlotTools.cpp
>  create mode 100644 kernel-shark-qt/src/KsPlotTools.hpp
>  create mode 100644 kernel-shark-qt/src/libkshark-plot.c
>  create mode 100644 kernel-shark-qt/src/libkshark-plot.h
> 
