Return-Path: <linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FECFC433FE
	for <linux-trace-devel@archiver.kernel.org>; Fri, 18 Nov 2022 09:31:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241937AbiKRJbJ (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Fri, 18 Nov 2022 04:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241940AbiKRJbH (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 18 Nov 2022 04:31:07 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 762D18B12E;
        Fri, 18 Nov 2022 01:31:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2md2gEsUQJxoAo1XmhLV28lHM6Rqe2aE3bcYs9xczcY=; b=WBzMGtkJsPbG2thGoYTYlmkkN6
        ZnF9i89mUYPxwjQpPLNN9/lVwb54BzkfPAzcw4mooLNVxmYt43tzkR9D8PcYAhiF+zfURFMi/BBhN
        3sRB701nMURS7GdJWrxNfavxMlIo+YEkaQChHM+lLExa2VkOV6Qtp+RbKlpqqF8Iexw89ZA9rxeKu
        ijNwiulFlKNahvPU1kySbap5ku0pUrdfp3lz00RksIAxM9mZsx2VDyd/micZsL+x4kkuRicFLF6JG
        VAKvrBMwwscKhpA9t9cc8+7d08vleIEQFOdNrQpUD1d6KayrTV4DrQLOA4N21vCIU9PQa1L2lshaW
        vBeM0iKA==;
Received: from j130084.upc-j.chello.nl ([24.132.130.84] helo=noisy.programming.kicks-ass.net)
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ovxhv-001w0a-KW; Fri, 18 Nov 2022 09:30:47 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 88F20300462;
        Fri, 18 Nov 2022 10:30:45 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 6A03D201AC447; Fri, 18 Nov 2022 10:30:45 +0100 (CET)
Date:   Fri, 18 Nov 2022 10:30:45 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ian Rogers <irogers@google.com>
Cc:     Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Steven Rostedt <rostedt@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH v1 1/2] perf build: Require libtraceevent from the system
Message-ID: <Y3dQxVNwGmQMWPP0@hirez.programming.kicks-ass.net>
References: <20221117224952.358639-1-irogers@google.com>
 <20221117224952.358639-2-irogers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117224952.358639-2-irogers@google.com>
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Thu, Nov 17, 2022 at 02:49:51PM -0800, Ian Rogers wrote:
> Unconditionally require libtraceevent to come from the system. Force
> the determination of the libtracefs version if it is present.

-ENOMOTIVATION

also:

Makefile.config:1196: *** Error: libtraceevent is missing, please install libtraceevent-dev.  Stop.

Why do I need this?
