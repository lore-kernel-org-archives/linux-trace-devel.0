Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E3F17C5
	for <linux-trace-devel@vger.kernel.org>; Fri,  6 Oct 2023 02:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10817C433C7;
	Fri,  6 Oct 2023 02:26:48 +0000 (UTC)
Date: Thu, 5 Oct 2023 22:27:59 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Ross Zwisler <zwisler@google.com>, Stevie Alvarez 
 <stevie.6strings@gmail.com>
Subject: Re: [PATCH] libtraceeval: Add traceeval_data_start/continue/stop()
 API
Message-ID: <20231005222759.5e99fa7b@gandalf.local.home>
In-Reply-To: <20231005222705.09a69c6e@gandalf.local.home>
References: <20231005222705.09a69c6e@gandalf.local.home>
X-Mailer: Claws Mail 3.19.1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 5 Oct 2023 22:27:05 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Subject: [PATCH] libtraceeval: Add traceeval_data_start/continue/stop() API

Bah, as it was sent, I noticed the subject said "data" and not "delta".

Oh well, I'm sure there's going to be a v2 on this.

-- Steve
