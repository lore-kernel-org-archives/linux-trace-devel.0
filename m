Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A47B01D54F
	for <linux-trace-devel@vger.kernel.org>; Mon,  2 Oct 2023 18:36:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B619FC433C8;
	Mon,  2 Oct 2023 18:36:12 +0000 (UTC)
Date: Mon, 2 Oct 2023 14:37:15 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ross Zwisler <zwisler@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: Re: [PATCH] libtraceeval: Fix comparing unsigned against zero
Message-ID: <20231002143715.229dffe5@gandalf.local.home>
In-Reply-To: <20231002183102.GA1512616@google.com>
References: <20230927041629.43ffbfd9@rorschach.local.home>
	<20231002183102.GA1512616@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 2 Oct 2023 12:31:02 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > @@ -303,14 +303,14 @@ struct traceeval *traceeval_init(struct traceeval_type *keys,
> >  
> >  	/* alloc key types */
> >  	teval->nr_key_types = type_alloc(keys, &teval->key_types);
> > -	if (teval->nr_key_types <= 0) {
> > +	if ((ssize_t)teval->nr_key_types <= 0) {  
> 
> Rather than casting, wouldn't it be better to just change the type of
> nr_key_types and nr_val_types to ssize_t?  I think this should be the return
> type of type_alloc() as well, since this returns -1 on error.

I thought about that, and there was a reason against it. But I forgot what
that was :-p

-- Steve
