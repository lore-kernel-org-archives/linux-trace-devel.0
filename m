Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F094421A448
	for <linux-trace-devel@vger.kernel.org>; Thu,  5 Dec 2024 14:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733409897; cv=none; b=AjYES8+xvUEZ8uV3gjtETZMNS2pLUye4IkZoJizFSzLzOzaFwgpJZ9GHYYzbVERuArWoWPwBWAgDdooidA0dSd0NnzOxvTpKQfVz77J+W5fG+hSRCGNRNeETheNOScpubAjffwxQ7rSQmJAoklCXvs2Pv2/etEIgO5VBYO9ADnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733409897; c=relaxed/simple;
	bh=j19Ng+jsX5NhnjzAk4phoQuCNtxGrdXqD5FSiiUN5p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4MNqIvH4UKuqKPhN239iRAhkw2ukrG61NW2sDqKCkEMNc+7NeR3w030thGrg0sbjyJQkGtsQ5xTedxDwtw3EJZ9lCMGKHiP4WwtgF6WJbecUnnMuOenrBUX2NfR3dtrBAU4eSWZ+CgxPV9dVrTcoiMwB0SIMhwP14hSW6iaxEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TezHZmr2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TezHZmr2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733409894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0e7gaiVl/TiW/eEI1WvYfc5LbK5oPuoiQGFibJZIWqU=;
	b=TezHZmr29nkb81A71NcjkAAq24Yg0QnP1Bgvvhl3Tm7k2+vqg01cCihQ4G7lZgL+xnHb7S
	XukRUcz9D2bd3/SLMYutX25m0/tH5h8kd0x1X8dWH5iQdBF32BM4NRzSdfFg/FFULMTWJK
	qg0yDBDCj169yZsKAMP+W3IDIh/9Acs=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-671-2qYg7Vz3PYOH04VU4h8Jdg-1; Thu,
 05 Dec 2024 09:44:51 -0500
X-MC-Unique: 2qYg7Vz3PYOH04VU4h8Jdg-1
X-Mimecast-MFC-AGG-ID: 2qYg7Vz3PYOH04VU4h8Jdg
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8287B19560A7;
	Thu,  5 Dec 2024 14:44:50 +0000 (UTC)
Received: from fedora (unknown [10.43.17.16])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with SMTP id 5209830001A1;
	Thu,  5 Dec 2024 14:44:48 +0000 (UTC)
Received: by fedora (sSMTP sendmail emulation); Thu, 05 Dec 2024 15:44:47 +0100
From: "Jerome Marchand" <jmarchan@redhat.com>
To: Linux Trace Devel <linux-trace-devel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Jerome Marchand <jmarchan@redhat.com>
Subject: [PATCH 2/7] trace-cmd lib: Prevent a memory leak in tracecmd_tsync_with_guest()
Date: Thu,  5 Dec 2024 15:44:34 +0100
Message-ID: <20241205144439.127564-3-jmarchan@redhat.com>
In-Reply-To: <20241205144439.127564-1-jmarchan@redhat.com>
References: <20241205144439.127564-1-jmarchan@redhat.com>
Precedence: bulk
X-Mailing-List: linux-trace-devel@vger.kernel.org
List-Id: <linux-trace-devel.vger.kernel.org>
List-Subscribe: <mailto:linux-trace-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-trace-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Free tsync->proto_name in tracecmd_tsync_with_guest() error path.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
---
 lib/trace-cmd/trace-timesync.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/lib/trace-cmd/trace-timesync.c b/lib/trace-cmd/trace-timesync.c
index 6ee4e643..94f31bcd 100644
--- a/lib/trace-cmd/trace-timesync.c
+++ b/lib/trace-cmd/trace-timesync.c
@@ -805,6 +805,7 @@ tracecmd_tsync_with_guest(unsigned long long trace_id, int loop_interval,
 		tracecmd_msg_handle_close(tsync->msg_handle);
 	else if (fd >= 0)
 		close(fd);
+	free(tsync->proto_name);
 	free(tsync);
 
 	return NULL;
-- 
2.47.0

