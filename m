Return-Path: <SRS0=+Nut=OX=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:37182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729935AbeLNRB6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 14 Dec 2018 12:01:58 -0500
Date: Fri, 14 Dec 2018 12:01:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH v2 5/8] kernel-shark-qt: Create "Apply filter XX"
 checkboxes in KsUtils
Message-ID: <20181214120155.706a68aa@gandalf.local.home>
In-Reply-To: <20181214125212.9637-6-ykaradzhov@vmware.com>
References: <20181214125212.9637-1-ykaradzhov@vmware.com>
        <20181214125212.9637-6-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Fri, 14 Dec 2018 12:52:39 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> The code responsible for the creation of the "Apply filters to Graph"
> and "Apply filters to List" checkboxes (showing in the "Filtering" menu),
> has been moved outside of the KsMainWindow class and is now available
> in KsUtils. This is done because we want to have the same checkboxes
> available in the KsQuickContextMenu.
> 

I applied this patch and it shows the "Hide CPU [x]". But it's a bit
flaky. The first time I tried it, it didn't do anything. Then after
starting kernelshark again, I was able to have it hide the CPU, but
when I clicked on the "Filter" menu on the top toolbar, the filter went
away.

Another thing, the "Apply filters to Graph" checkbox is a bit
confusing. What does it actually mean? The filters are applied by
default to the graph, correct? But the checkbox isn't set.

Also, does it make sense to have that "Apply filters to graph" checkbox
in the Graph menu. It would make more sense if it said "Apply filters
to table".

I think I'll apply this series except for this patch and the last one
(5 and 8).

-- Steve
