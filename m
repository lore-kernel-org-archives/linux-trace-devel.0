Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8E96EB62
	for <linux-trace-devel@vger.kernel.org>; Fri, 12 Jan 2024 15:35:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC568C433C7;
	Fri, 12 Jan 2024 15:34:59 +0000 (UTC)
Date: Fri, 12 Jan 2024 10:36:04 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Pierre Gondois <pierre.gondois@arm.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH 0/5] trace-cmd: split: Handle splitting files with
 multiple instances
Message-ID: <20240112103604.3185a864@gandalf.local.home>
In-Reply-To: <20240112083945.1361293-1-pierre.gondois@arm.com>
References: <20240112083945.1361293-1-pierre.gondois@arm.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 12 Jan 2024 09:39:40 +0100
Pierre Gondois <pierre.gondois@arm.com> wrote:

> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=218357
> 

Hi Pierre!

Thanks for sending these.

> Splitting trace files having multiple buffer instances discards
> side-buffers . I.e., only the main buffer is preserved in the
> resulting split trace files. This patch-set intends to fix this.
> 
> Also:
> - Fix a side issue preventing to provide start/end timestamps
>   along with a time-window parameters.
> - Update trace-cmd split usage
> 
> Pierre Gondois (5):
>   trace-cmd: split: Small fixes

One small nit, and you do not need to resend for this, but for future
patches. You do not need the colon after trace-cmd. That is:


  trace-cmd split: Small fixes

is good enough. In Linux some sub-systems use this method for when a patch
affects two sub-systems.

  <subsystemA>: <subsystemB>: Subject

But here it's representing the actual command.

    "trace-cmd split" is being fixed.


>   trace-cmd: usage: Update usage for trace-cmd split

If just fixing the usage of a single command, I would have that be:

   trace-cmd split: Update usage to include input file and CPU select

-- Steve

>   trace-cmd: split: Store instances in local list
>   trace-cmd: split: Add functions to generate temp files
>   trace-cmd: split: Handle splitting files with multiple instances
> 
>  tracecmd/trace-split.c | 231 +++++++++++++++++++++++++++++------------
>  tracecmd/trace-usage.c |   3 +-
>  2 files changed, 167 insertions(+), 67 deletions(-)
> 

