Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A8A42BF4
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Oct 2023 21:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2962FC433C8;
	Thu,  5 Oct 2023 21:58:44 +0000 (UTC)
Date: Thu, 5 Oct 2023 17:59:54 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ross Zwisler <zwisler@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: Re: [PATCH] libtraceeval: Use trick to force static array usage
 where needed
Message-ID: <20231005175954.77c6c1da@gandalf.local.home>
In-Reply-To: <20231005212521.GA3146009@google.com>
References: <20231004185225.366c1739@gandalf.local.home>
	<20231005212521.GA3146009@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 5 Oct 2023 15:25:21 -0600
Ross Zwisler <zwisler@google.com> wrote:

> That's some scary deep magic.  :)

Yeah it is. Hence the detailed change log, and not just:

  "The macro prevents static traceeval_data *keys from being used"

> 
> We may want to add a comment above this to briefly explain, i.e. "This macro
> will fail to build if 'data' is a pointer and not a static array" and refer
> them to the commit history?  That way they have some way to proceed if/when
> their build fails.

Well, I don't think they need to understand how the macro work. But just
why it failed. Even though new compilers also warn about why it doesn't
work, I can still add:

/*
 * If your compile failed due to the below macro, it is likely you used
 * a pointer to struct traceeval_data, and not a static array.
 *
 * That is:
 *
 *    struct traceeval_data *keys;
 *
 * and not:
 *
 *    struct traceeval_data keys[] = { ... };
 */

I'll send a v2

> 
> Otherwise looks good:
> Reviewed-by: Ross Zwisler <zwisler@google.com>

Thanks!

-- Steve

