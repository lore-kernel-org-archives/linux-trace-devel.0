Return-Path: <SRS0=ZGqO=MP=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:52440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726950AbeJDC0Q (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Wed, 3 Oct 2018 22:26:16 -0400
Date: Wed, 3 Oct 2018 15:36:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <y.karadz@gmail.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: Some more updates for KernelShark
Message-ID: <20181003153628.18ca2c24@gandalf.local.home>
In-Reply-To: <20181003145740.06cd80d6@gandalf.local.home>
References: <20181003141552.1600bfa9@gandalf.local.home>
        <20181003145458.165568c6@gandalf.local.home>
        <20181003145740.06cd80d6@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Wed, 3 Oct 2018 14:57:40 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Another enhancement (not required for 1.0 as the above requests are),
> is to have the designated color of the tasks be the background of the
> text of the tasks name in the left. And we can do the same for the CPUs.

Another non 1.0 enhancement is a "back" button. After doing a zoom with
a dragging of the mouse, a back button would bring you back to the zoom
before you did the drag.

That is, several times I zoom in with the mouse (quick zoom) and then
want to come back out to where I did before that quick zoom, but
unfortunately there's no quick way to do that :-/

-- Steve
