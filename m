Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48C21A09
	for <linux-trace-devel@vger.kernel.org>; Wed, 11 Oct 2023 23:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390DBC433C8;
	Wed, 11 Oct 2023 23:12:43 +0000 (UTC)
Date: Wed, 11 Oct 2023 19:14:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ross Zwisler <zwisler@google.com>
Cc: Linux Trace Devel <linux-trace-devel@vger.kernel.org>, Stevie Alvarez
 <stevie.6strings@gmail.com>
Subject: Re: [PATCH v2] libtraceeval: Have TRACEEVAL_ARRAY_SIZE() handle
 NULL pointer
Message-ID: <20231011191406.5c93f6ae@gandalf.local.home>
In-Reply-To: <20231011223348.GB94116@google.com>
References: <20231005212233.22ae4e13@rorschach.local.home>
	<20231011223348.GB94116@google.com>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Oct 2023 16:33:48 -0600
Ross Zwisler <zwisler@google.com> wrote:

> On Thu, Oct 05, 2023 at 09:22:33PM -0400, Steven Rostedt wrote:
> > From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> > 
> > In the new addition to make sure that pointers passed to traceeval_init()
> > and other functions that require a static array and not a dynamic one will
> > cause the build to fail, this causes NULL pointers to fail the build too.
> > 
> > Although keys must be filled, vals are allowed to be NULL. It was assumed
> > that:
> > 
> >    (void *)vals == NULL ? TRACEEVAL_ARRAY_SIZE(vals))
> > 
> > Would solve this, but it gcc was actually still giving a warning about
> > 
> >   warning: division 'sizeof (void *) / sizeof (void)' does not compute the number of array elements
> > 
> > But now it actually fails to build with the magic check.
> > 
> > Change TRACEEVAL_ARRAY_SIZE() to handle NULL for both keys and vals, by
> > not only having:
> > 
> >  #define TRACEEVAL_ARRAY_SIZE(data) \
> > 	((void *)(data) == NULL ?  0 : __TRACEEVAL_ARRAY_SIZE(data))
> > 
> > But that is not enough, as gcc still evaluates the second part, and it
> > will fail to build. To handle this, change that to:
> > 
> >  #define __TRACEEVAL_ARRAY_SIZE(data)					\
> > 	((sizeof(data) / (sizeof((data)[0])) + 0) +			\
> > 
> > The above adds " + 0" to the "sizeof((data)[0])" which quiets the warning
> > mentioned above (the addition of zero breaks the normal pattern of finding
> > an array size).
> > 
> > 	(int)(sizeof(struct {						\
> > 		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
> > 						      typeof(&((data)[0]))) && \
> > 			 (void *)(data) != NULL));			\
> > 
> > Added "&& (void *)(data) != NULL" that makes the above return false (zero)
> > for a static array and NULL, which is exactly what we want.  
> 
> Don't we already know it's not NULL because of the check in
> TRACEEVAL_ARRAY_SIZE()?  Or do we really need to check for NULL in both
> macros?

Unfortunately what happens is that the compiler still checks the above. So
if we have just:

 	(int)(sizeof(struct {						\
 		int:(-!!(__builtin_types_compatible_p(typeof(data),	\
 						      typeof(&((data)[0])))));


Then the with NULL turns into:

	struct { int: -1; }

and fails the compile because:

 		__builtin_types_compatible_p(typeof(NULL), typeof(&((NULL)[0])))

Returns true.

So if we pair that with (void *)(data) != NULL, it will then return false
and turns into:

	struct { int: 0; }

Which is valid.

> 
> > 
> > 			})))  
> 
> A few random parens in the changelog. :)
> 

Yeah, the code had it too and I had to fix it. But didn't update the change log. :-p

-- Steve
