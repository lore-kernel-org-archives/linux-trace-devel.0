Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E7C22EE9
	for <linux-trace-devel@vger.kernel.org>; Wed,  4 Oct 2023 21:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD28BC433C7;
	Wed,  4 Oct 2023 21:53:20 +0000 (UTC)
Date: Wed, 4 Oct 2023 17:54:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ross Zwisler <zwisler@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Subject: Re: [PATCH] libtraceeval: Use name for type look up for
 traceeval_stat
Message-ID: <20231004175428.3cf5b2d2@gandalf.local.home>
In-Reply-To: <20231004145654.GA2510728@google.com>
References: <20231003181237.616cc8db@gandalf.local.home>
	<20231004145654.GA2510728@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 4 Oct 2023 08:56:54 -0600
Ross Zwisler <zwisler@google.com> wrote:


> Probably need to also s/type/val_name/g for the traceeval_stat() macro so they
> stay in sync, and need to update the calls to traceeval_iterator_stat() and

Makes sense.

> traceeval_stat() in samples/task-eval.c so they continue to work.

Ah, I had that as a separate patch (never sent it). But it makes more sense
to just fold it into this one.

-- Steve

