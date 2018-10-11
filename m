Return-Path: <SRS0=tdNt=MX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:45384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726040AbeJLEoQ (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 12 Oct 2018 00:44:16 -0400
Date: Thu, 11 Oct 2018 17:15:10 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v3 0/4] Add basic components to be used by the Qt GUI
Message-ID: <20181011171510.43833c2a@gandalf.local.home>
In-Reply-To: <20181011165713.15257-1-ykaradzhov@vmware.com>
References: <20181011165713.15257-1-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Thu, 11 Oct 2018 16:57:37 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> This series of patches introduces the first components of the Qt-based
> KernelShark GUI. It includes some basic utils, as well as various small
> widgets and dialogues used by the GUI. The GUI itself will be introdused
> in the following series.
> 
> This is the second version of this series of patches. It includes a
> code rebase, after pulling the latest patches from upstream.
> 
> Yordan Karadzhov (VMware) (4):
>   kernel-shark-qt: Add Qt as a third party dependency.
>   kernel-shark-qt: Add KernalShark Utils
>   kernel-shark-qt: Add Widgets Lib
>   kernel-shark-qt: Add widget demo example.

Applied. Thanks Yordan!

-- Steve

> 
>  kernel-shark-qt/CMakeLists.txt          |   8 +
>  kernel-shark-qt/README                  |   6 +-
>  kernel-shark-qt/build/deff.h.cmake      |  16 +
>  kernel-shark-qt/examples/CMakeLists.txt |   4 +
>  kernel-shark-qt/examples/widgetdemo.cpp | 158 +++++
>  kernel-shark-qt/src/CMakeLists.txt      |  22 +
>  kernel-shark-qt/src/KsUtils.cpp         | 594 ++++++++++++++++
>  kernel-shark-qt/src/KsUtils.hpp         | 233 +++++++
>  kernel-shark-qt/src/KsWidgetsLib.cpp    | 881 ++++++++++++++++++++++++
>  kernel-shark-qt/src/KsWidgetsLib.hpp    | 385 +++++++++++
>  10 files changed, 2306 insertions(+), 1 deletion(-)
>  create mode 100644 kernel-shark-qt/examples/widgetdemo.cpp
>  create mode 100644 kernel-shark-qt/src/KsUtils.cpp
>  create mode 100644 kernel-shark-qt/src/KsUtils.hpp
>  create mode 100644 kernel-shark-qt/src/KsWidgetsLib.cpp
>  create mode 100644 kernel-shark-qt/src/KsWidgetsLib.hpp
> 
