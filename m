Return-Path: <SRS0=ZGqO=MP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:49240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726851AbeJDBiO (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Oct 2018 21:38:14 -0400
Date: Wed, 3 Oct 2018 14:48:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Still problem with red preempted boxes for tasks
Message-ID: <20181003144835.23f09933@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

Hi Yordan,

While looking at my data, I found that the red empty boxes to represent
preemption for task plots is still unreliable.

Down load this: http://rostedt.org/private/trace-views.tar.bz2

Then in the /tmp directory:

 /tmp$ tar xvf trace-views.tar.bz2

Start up KernelShark, and import view1.json. Notice the red preemption
box and what tasks they are for. Then load view2.json and do the same,
the view3.json, and that as well. You'll notice that each one gives
different preemption boxes in the same location.

-- Steve

P.S. The session files really help with passing you debugging info like
this :-)
