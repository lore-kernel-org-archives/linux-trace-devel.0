Return-Path: <SRS0=lMx0=LH=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:47254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725951AbeHXFPY (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 24 Aug 2018 01:15:24 -0400
Date: Thu, 23 Aug 2018 21:43:01 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Matthew Helsley <mhelsley@vmware.com>
Cc: "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>,
        "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 3/5] kernel-shark-qt: Add C++ API for drawing of Graphs
Message-ID: <20180823214301.26abbfeb@vmware.local.home>
In-Reply-To: <EE0F70F1-9D62-46A0-9C6C-F0FE88EAFDFF@vmware.com>
References: <20180822154140.3748-1-y.karadz@gmail.com>
        <20180822154140.3748-4-y.karadz@gmail.com>
        <EE0F70F1-9D62-46A0-9C6C-F0FE88EAFDFF@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>


Hi Matt,

Did you expect to reply here?

-- Steve


On Thu, 23 Aug 2018 20:20:20 +0000
Matthew Helsley <mhelsley@vmware.com> wrote:

> > On Aug 22, 2018, at 8:41 AM, Yordan Karadzhov (VMware) <y.karadz@gmail.com> wrote:
> > 
> > This patch extends the KernelShark Plotting library, by adding
> > a C++ API for drawing CPU and Task Graphs.
> > 
> > Signed-off-by: Yordan Karadzhov (VMware) <y.karadz@gmail.com>
> > ---
> > kernel-shark-qt/src/CMakeLists.txt  |    3 +-
> > kernel-shark-qt/src/KsPlotTools.cpp | 1009 +++++++++++++++++++++++++++
> > kernel-shark-qt/src/KsPlotTools.hpp |  440 ++++++++++++
> > 3 files changed, 1451 insertions(+), 1 deletion(-)
> > create mode 100644 kernel-shark-qt/src/KsPlotTools.cpp
> > create mode 100644 kernel-shark-qt/src/KsPlotTools.hpp
