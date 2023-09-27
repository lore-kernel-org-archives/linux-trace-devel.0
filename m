Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE2F208A3
	for <linux-trace-devel@vger.kernel.org>; Wed, 27 Sep 2023 09:09:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 174DAC433C7;
	Wed, 27 Sep 2023 09:09:26 +0000 (UTC)
Date: Wed, 27 Sep 2023 05:09:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ross Zwisler <zwisler@google.com>
Cc: linux-trace-devel@vger.kernel.org, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: Re: [PATCH 4/9] libtraceeval: Add traceeval_iterator_remove()
Message-ID: <20230927050922.37710056@rorschach.local.home>
In-Reply-To: <20230824201906.GD110858@google.com>
References: <20230817222422.118568-1-rostedt@goodmis.org>
	<20230817222422.118568-5-rostedt@goodmis.org>
	<20230824201906.GD110858@google.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 24 Aug 2023 14:19:06 -0600
Ross Zwisler <zwisler@google.com> wrote:

> > +int traceeval_iterator_remove(struct traceeval_iterator *iter)
> > +{
> > +	struct traceeval *teval = iter->teval;
> > +	struct hash_table *hist = teval->hist;
> > +	struct entry *entry;
> > +
> > +	if (iter->next < 1 || iter->next > iter->nr_entries)
> > +		return 0;
> > +
> > +	entry = iter->entries[iter->next - 1];
> > +	if (!entry)
> > +		return 0;
> > +
> > +	hash_remove(hist, &entry->hash);  
> 
> Are we leaking 'entry' after we've removed it from the hash?

Yeah, I guess we are. Good catch!

> 
> I think we need to call free_entry() in both traceeval_iterator_remove() as
> well as traceeval_remove(), just like we do in the loop in
> hist_table_release().

Yep, thanks Ross!

-- Steve

> 
> > +
> > +	/* The entry no longer exists */
> > +	iter->entries[iter->next - 1] = NULL;
> > +	teval->update_counter++;
> > +
> > +	return 1;
> >  }
> > -- 
> > 2.40.1
> >   

