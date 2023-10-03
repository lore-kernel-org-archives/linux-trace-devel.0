Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AAB0347A2
	for <linux-trace-devel@vger.kernel.org>; Tue,  3 Oct 2023 15:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15BC0C433C8;
	Tue,  3 Oct 2023 15:42:56 +0000 (UTC)
Date: Tue, 3 Oct 2023 11:44:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ross Zwisler <zwisler@google.com>
Cc: linux-trace-devel@vger.kernel.org, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2 1/2] libtraceeval: Remove need to use
 TRACEEVAL_TYPE_NONE in keys and vals
Message-ID: <20231003114402.28d9feeb@gandalf.local.home>
In-Reply-To: <20231003153920.GC1935474@google.com>
References: <20231003140802.1139616-1-rostedt@goodmis.org>
	<20231003140802.1139616-2-rostedt@goodmis.org>
	<20231003153920.GC1935474@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 3 Oct 2023 09:39:20 -0600
Ross Zwisler <zwisler@google.com> wrote:

> IMO trying to support both types of inputs (ending with TRACEEVAL_TYPE_NONE
> and just relying on the element count) is probably bad long term because one
> or the other will break and we may not notice, and we'll have to make sure we
> keep up both.

I plan on really only supporting the one type (defined size), the
TRACEEVAL_TYPE_NONE will not be shown in the man pages. The reason I want
to keep them is mostly for debugging (can add this to test issues and what not).

So yeah, I agree we only want to support one, and we are going to do that,
but the other will still be there "hidden" from the users ;-)

> 
> As we don't really have users yet (do we?) can we just move fully over to the
> count way and give on the other?
> 
> In either case, we probably need to still update the comments above
> type_alloc(), traceeval_init_data_size() and traceeval_insert_size() which
> talk about how we rely on TRACEEVAL_TYPE_NONE to terminate our element lists.

Will do that in another patch. But right now I'm working on the man pages,
and that's really where I expect people to get their information on how to
use the library.

> 
> What we have here though is correct:
> Reviewed-by: Ross Zwisler <zwisler@google.com>

Thanks,

-- Steve
