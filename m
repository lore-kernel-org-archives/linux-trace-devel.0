Return-Path: linux-trace-devel-owner@vger.kernel.org
Received: from mail.kernel.org ([198.145.29.99]:35418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932157AbeBGA1O (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 6 Feb 2018 19:27:14 -0500
Date: Tue, 6 Feb 2018 19:27:11 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com>
Cc: linux-trace-devel@vger.kernel.org, y.karadz@gmail.com
Subject: Re: [PATCH v2 00/24] trace-cmd: restructure the project's source
 tree
Message-ID: <20180206192711.0ac2a94b@gandalf.local.home>
In-Reply-To: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
References: <20180206084906.9854-1-vladislav.valtchev@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue,  6 Feb 2018 10:48:42 +0200
"Vladislav Valtchev (VMware)" <vladislav.valtchev@gmail.com> wrote:

> This series restructures trace-cmd's source tree in a way that each
> component inside the repo has its own directory. Now the two libraries, the
> GUI apps, the plugins, the python C modules, the trace-cmd's application
> and all of their headers are organized in dedicated directories. Almost all
> of the effort in this series has been spent on updating the build system to
> support the new structure. The side-effect of that is a simpler and easier
> to maintain build system.
> 
> NOTE: this rebased v2 series embeds now the previous mini-series called
> "trace-cmd: Make out-of-tree builds to work" which, as the title suggests,
> restores the out-of-tree build feature that is currently broken on the
> master branch.

Thanks Vladislav!

I applied them all. I'll be doing some more testing on them before
pushing them to kernel.org, but I didn't see anything wrong with them.

-- Steve
