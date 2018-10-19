Return-Path: <SRS0=XbHK=M7=vger.kernel.org=linux-trace-devel-owner@goodmis.org>
Received: from mail.kernel.org ([198.145.29.99]:35892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbeJSKJg (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Fri, 19 Oct 2018 06:09:36 -0400
Date: Thu, 18 Oct 2018 22:05:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Yordan Karadzhov <ykaradzhov@vmware.com>
Cc: "linux-trace-devel@vger.kernel.org"
        <linux-trace-devel@vger.kernel.org>,
        Yordan Karadzhov <y.karadz@gmail.com>
Subject: Re: [PATCH v2 02/23] kernel-shark-qt: Add Dual Marker for
 KernelShark GUI.
Message-ID: <20181018220540.0f299e37@vmware.local.home>
In-Reply-To: <20181016155232.5257-3-ykaradzhov@vmware.com>
References: <20181016155232.5257-1-ykaradzhov@vmware.com>
        <20181016155232.5257-3-ykaradzhov@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-trace-devel-owner@vger.kernel.org
List-ID: <linux-trace-devel.vger.kernel.org>

On Tue, 16 Oct 2018 15:52:58 +0000
Yordan Karadzhov <ykaradzhov@vmware.com> wrote:

> +
> +/** Get the Graph marker associated with a given state. */ 

Also be careful about extre whitespace. There's a extra space at the
end of the above line.

(I removed it in the commit).

-- Steve

> +KsGraphMark &KsDualMarkerSM::getMarker(DualMarkerState s)
> +{
> +	if (s == DualMarkerState::A)
> +		return _markA;
> +
> +	return _markB;
> +}
