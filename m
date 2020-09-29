Return-Path: <SRS0=wnl5=DG=vger.kernel.org=linux-trace-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8775C4727C
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 21:05:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E3112074F
	for <linux-trace-devel@archiver.kernel.org>; Tue, 29 Sep 2020 21:05:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728443AbgI2VF6 (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Tue, 29 Sep 2020 17:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726643AbgI2VF6 (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Tue, 29 Sep 2020 17:05:58 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C44F72074F;
        Tue, 29 Sep 2020 21:05:57 +0000 (UTC)
Date:   Tue, 29 Sep 2020 17:05:55 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     "Yordan Karadzhov (VMware)" <y.karadz@gmail.com>
Cc:     linux-trace-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] kernel-shark :Fix all build warnings for gcc 10.2.1
Message-ID: <20200929170555.3f45e952@gandalf.local.home>
In-Reply-To: <20200916065007.9755-1-y.karadz@gmail.com>
References: <20200916065007.9755-1-y.karadz@gmail.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

On Wed, 16 Sep 2020 09:50:04 +0300
"Yordan Karadzhov (VMware)" <y.karadz@gmail.com> wrote:

> @@ -606,21 +603,17 @@ void KsTraceGraph::_updateGraphLegends()
>  void KsTraceGraph::_updateTimeLegends()
>  {
>  	uint64_t sec, usec, tsMid;
> -	QString tMin, tMid, tMax;
>  
>  	kshark_convert_nano(_glWindow.model()->histo()->min, &sec, &usec);
> -	tMin.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
> -	_labelXMin.setText(tMin);
> +	_labelXMin.setText(_t2str(sec, usec));
>  
>  	tsMid = (_glWindow.model()->histo()->min +
>  		 _glWindow.model()->histo()->max) / 2;
>  	kshark_convert_nano(tsMid, &sec, &usec);
> -	tMid.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
> -	_labelXMid.setText(tMid);
> +	_labelXMid.setText(_t2str(sec, usec));
>  
>  	kshark_convert_nano(_glWindow.model()->histo()->max, &sec, &usec);
> -	tMax.sprintf("%" PRIu64 ".%06" PRIu64 "", sec, usec);
> -	_labelXMax.setText(tMax);
> +	_labelXMax.setText(_t2str(sec, usec));
>  }
>  
>  /**
> diff --git a/kernel-shark/src/KsTraceGraph.hpp b/kernel-shark/src/KsTraceGraph.hpp
> index c53258c..8abc06b 100644
> --- a/kernel-shark/src/KsTraceGraph.hpp
> +++ b/kernel-shark/src/KsTraceGraph.hpp
> @@ -108,6 +108,10 @@ private:
>  
>  	void _markerReDraw();
>  
> +	QString _t2str(uint64_t sec, uint64_t usec) {
> +		return QString::number(sec) + "." + QString::number(usec);

Hmm, if sec is 5 and usec is 1, would the above work? That is, would it
give:

	"5.000001"

Or would it give:

	"5.1"

which would be wrong.

-- Steve

> +	};
> +
>  	enum class GraphActions {
>  		ZoomIn,
>  		ZoomOut,
