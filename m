Return-Path: <linux-trace-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2F8DEB64D7
	for <linux-trace-devel@archiver.kernel.org>; Mon, 26 Jun 2023 09:20:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjFZJUS (ORCPT
        <rfc822;linux-trace-devel@archiver.kernel.org>);
        Mon, 26 Jun 2023 05:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjFZJTi (ORCPT
        <rfc822;linux-trace-devel@vger.kernel.org>);
        Mon, 26 Jun 2023 05:19:38 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25CC410DE
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jun 2023 02:17:01 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id a640c23a62f3a-98e109525d6so290648266b.0
        for <linux-trace-devel@vger.kernel.org>; Mon, 26 Jun 2023 02:17:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687771019; x=1690363019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jajLnawW651XBwfEFnMq3+Y5XmyzQflq7MAKne2Mc0=;
        b=cTZiPmukD0o4ks0Y2Y5d9us+W8G4cTt3uiJomhTWjv5zZg9LZE+gk9fyUO6oqTgyOB
         xqQOUKFSSeAZoKpLKNOJilfam2C8NynTPWzKPTU5JYO9zmonjT9awTlp2rAVCXjBfFus
         rReCBBQUMrnA1g+exwBBJhFiQRO1LC1b708QPgzwqVdPXfy5SwolaLLUlmTabMzMkAEl
         VYj8rbzeKmqLjaM2DigmIbtjIbNv+OkXkQLjs47+xD8IGFluZpsWhPaiOHeKBm4xGwRo
         KtZTpMMNakA54+wOGURv5f7V4cp7qPkNGkLtt8Bt+ZtZI0fkiUPkhKMHD6f8dA4xfbAV
         aGIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687771019; x=1690363019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3jajLnawW651XBwfEFnMq3+Y5XmyzQflq7MAKne2Mc0=;
        b=bw5w00IjxjQ4ssj89A5W9/uyN7M0OEzLqsKa9F5wG//MVPwzR6ZV2L+ffsI0xGZxud
         h3aFJA8Ct0NBKsuPIjB+zCxTn3UpJJqQkBBmpCxQeaWCNI2P3BoisHIwiDcuTLf2z8kC
         94w2tUaZLZBlB9MtlomNpVorLhZOwwjNk9PdcyH9aF53ea2aiIpQKqD2LkcBKodwrNW8
         wA/aMIGfX6uXGbmceuOMFXbYNwwJL/1JuoC3SIlg2i2MNsDaMsaK3pur1VSWTLWJIAg4
         4eC2wwiQvFduYJ1YvvnPeFqGfKJuu1aR81l7Qz/fzX29rVpyx/OqcLBNXV9aeclq+pFD
         SOJQ==
X-Gm-Message-State: AC+VfDwvOCMLMVmq7XvzsaWZnyKAii5onV/ZOmtUjoc0oMCQCbna4bZR
        +jr8Pl6QtP0vLcLQ9klRxDLQXJ1AH788hA==
X-Google-Smtp-Source: ACHHUZ7fo9BzTnXjr8aYuqaM53bAq/yHdsQ9mmtUZWp+ZWZtWCDUU9MfGZ3Og2ehBVeSOhDWPfidrQ==
X-Received: by 2002:a17:907:9483:b0:989:4952:bfa5 with SMTP id dm3-20020a170907948300b009894952bfa5mr14269499ejc.30.1687771019290;
        Mon, 26 Jun 2023 02:16:59 -0700 (PDT)
Received: from dante731.cslcs.technion.ac.il ([132.68.206.91])
        by smtp.gmail.com with ESMTPSA id lc1-20020a170906f90100b00988e953a586sm3061414ejb.61.2023.06.26.02.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jun 2023 02:16:59 -0700 (PDT)
From:   avidanborisov@gmail.com
To:     linux-trace-devel@vger.kernel.org
Cc:     rostedt@goodmis.org, avidanborisov@gmail.com
Subject: [PATCH v2 4/4] trace-cmd record: Add --daemonize example to man page
Date:   Mon, 26 Jun 2023 12:16:35 +0300
Message-Id: <20230626091635.3002827-5-avidanborisov@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230626091635.3002827-1-avidanborisov@gmail.com>
References: <20230530045119.30c8d973@rorschach.local.home>
 <20230626091635.3002827-1-avidanborisov@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-trace-devel.vger.kernel.org>
X-Mailing-List: linux-trace-devel@vger.kernel.org

From: Avidan Borisov <avidanborisov@gmail.com>

Add a small usage example of how --daemonize can be used with guest/host tracing for analyzing network activity.

Signed-off-by: Avidan Borisov <avidanborisov@gmail.com>
---
 .../trace-cmd/trace-cmd-record.1.txt          | 29 +++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/Documentation/trace-cmd/trace-cmd-record.1.txt b/Documentation/trace-cmd/trace-cmd-record.1.txt
index 0c9a914..79ab3d0 100644
--- a/Documentation/trace-cmd/trace-cmd-record.1.txt
+++ b/Documentation/trace-cmd/trace-cmd-record.1.txt
@@ -515,6 +515,35 @@ task: sleep-21611
        => try_to_wake_up (0xffffffff8106340a)
 ----
 
+An example of using --daemonize together with guest/host tracing:
+[source,shell]
+----
+$ sudo trace-cmd record --daemonize -p nop -e 'sched:sched_process_exec' -A guest -p nop -e net &&
+> ping -c 1 10.20.1.2 &&
+> sudo start-stop-daemon --stop --signal INT --retry 20 --pidfile /var/run/trace-cmd-record.pid &&
+> sudo trace-cmd report -i trace.dat -i trace-guest.dat | head
+Negotiated kvm time sync protocol with guest guest
+Send SIGINT to pid 3071371 to stop recording
+PING 10.20.1.2 (10.20.1.2) 56(84) bytes of data.
+64 bytes from 10.20.1.2: icmp_seq=1 ttl=64 time=0.134 ms
+--- 10.20.1.2 ping statistics ---
+1 packets transmitted, 1 received, 0% packet loss, time 0ms
+rtt min/avg/max/mdev = 0.134/0.134/0.134/0.000 ms
+CPU0 data recorded at offset=0x14f000
+    229 bytes in size (4096 uncompressed)
+....
+      trace.dat: cpus=28
+trace-guest.dat: cpus=1
+      trace.dat:           ping-3071450 [013] 1196830.834258: sched_process_exec:     filename=/bin/ping pid=3071450 old_pid=3071450
+trace-guest.dat:           <idle>-0     [000] 1196830.835990: napi_gro_receive_entry: dev=eth1 napi_id=0x2002 queue_mapping=1 skbaddr=0xffff95d051a5c400 vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800 ip_summed=0 hash=0x00000000 l4_hash=0 len=84 data_len=0 truesize=768 mac_header_valid=1 mac_header=-14 nr_frags=0 gso_size=0 gso_type=0
+trace-guest.dat:           <idle>-0     [000] 1196830.835997: napi_gro_receive_exit:  ret=3
+trace-guest.dat:           <idle>-0     [000] 1196830.835998: netif_receive_skb:      dev=eth1 skbaddr=0xffff95d051a5c400x len=84
+trace-guest.dat:           <idle>-0     [000] 1196830.836021: net_dev_queue:          dev=eth1 skbaddr=0xffff95d051a5c700x len=98
+trace-guest.dat:           <idle>-0     [000] 1196830.836024: net_dev_start_xmit:     dev=eth1 queue_mapping=0 skbaddr=0xffff95d051a5c700 vlan_tagged=0 vlan_proto=0x0000 vlan_tci=0x0000 protocol=0x0800 ip_summed=0 len=98 data_len=0 network_offset=14 transport_offset_valid=1 transport_offset=34 tx_flags=0 gso_size=0 gso_segs=0 gso_type=0
+trace-guest.dat:           <idle>-0     [000] 1196830.836069: net_dev_xmit:           dev=eth1 skbaddr=0xffff95d051a5c700 len=98 rc=0
+      trace.dat:           sudo-3071451 [015] 1196830.838262: sched_process_exec:     filename=/usr/bin/sudo pid=3071451 old_pid=3071451
+----
+
 SEE ALSO
 --------
 trace-cmd(1), trace-cmd-report(1), trace-cmd-start(1), trace-cmd-stop(1),
-- 
2.25.1

