Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409FD1F5EE
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 09:51:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB884C433C8;
	Wed, 27 Sep 2023 09:51:47 +0000 (UTC)
Date: Wed, 27 Sep 2023 05:51:43 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ross Zwisler <zwisler@google.com>
Cc: linux-trace-devel@vger.kernel.org, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: Re: [PATCH 4/9] libtraceeval: Add traceeval_iterator_remove()
Message-ID: <20230927055143.3ee79e98@rorschach.local.home>
In-Reply-To: <20230824202324.GE110858@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
	<20230817222422.118568-5-rostedt@goodmis.org>
	<20230824201906.GD110858@google.com>
	<20230824202324.GE110858@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 24 Aug 2023 14:23:24 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > > + * Returns 1 if it successfully removed the entry, 0 if for some reason
> > > + * there was no "current entry" (called before traceeval_iterator_next()).
> > > + * or -1 on error.  
> 
> Nit: we never actually return -1.  Only 1 and 0.
> 

Yeah, I usually just throw the -1 in there in case I want to add more
error checking, but since 1 is success, I'll just make it 1 and 0
anyway.

Thanks,

-- Steve
